local fn = vim.fn

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
      ensure_installed = {
        "taplo",
        "lua_ls",
        "bashls",
        "ts_ls",
        "pyright",
        "jsonls",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      local function go_to_definition_dedup()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if not clients or #clients == 0 then
          vim.notify("No language server attached.", vim.log.levels.INFO)
          return
        end

        local all_locations = {}
        local results_count = 0

        local function process_all_results()
          if #all_locations == 0 then
            vim.notify("Definition not found.", vim.log.levels.INFO)
            return
          end

          local unique_locations = {}
          local seen_locations = {}
          for _, loc in ipairs(all_locations) do
            if loc and loc.uri and loc.range then
              local loc_str = string.format("%s:%d:%d", loc.uri, loc.range.start.line, loc.range.start.character)
              if not seen_locations[loc_str] then
                table.insert(unique_locations, loc)
                seen_locations[loc_str] = true
              end
            end
          end

          if #unique_locations == 0 then
            vim.notify("Definition not found (or received invalid locations).", vim.log.levels.INFO)
            return
          end

          -- Use the encoding of the first client to satisfy the new API requirement
          local first_client_encoding = clients[1].offset_encoding
          vim.lsp.util.show_document(unique_locations[1], { position_encoding = first_client_encoding, focus = true })
          if #unique_locations > 1 then
            vim.lsp.util.show_locations(unique_locations, "Definitions", { position_encoding = first_client_encoding })
          end
        end

        local function on_result(err, result, ctx)
          results_count = results_count + 1
          if result and not vim.tbl_isempty(result) then
            -- Use the new recommended function to avoid deprecation warnings
            local locations = vim.islist(result) and result or { result }
            for _, loc in ipairs(locations) do
              if loc.targetUri and loc.targetRange then
                table.insert(all_locations, { uri = loc.targetUri, range = loc.targetRange })
              elseif loc.uri and loc.range then
                table.insert(all_locations, loc)
              end
            end
          end

          if results_count == #clients then
            vim.schedule(process_all_results)
          end
        end

        for _, client in ipairs(clients) do
          local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
          client.request("textDocument/definition", params, on_result, 0)
        end
      end

      local on_attach = function(client, bufnr)
        -- Keymaps for LSP functionality
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
        vim.keymap.set("n", "<leader>gd", go_to_definition_dedup, { buffer = bufnr, desc = "Go to definition" })
        vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Find references" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })

        if client.supports_method "textDocument/foldingRange" then
          vim.o.foldmethod = "expr"
          vim.o.foldexpr = "nvim_treesitter#foldexpr()"
        end
      end

      -- Setup for TOML language server
      lspconfig.taplo.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      -- Setup for Lua language server
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT)
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- Setup for Bash language server
      lspconfig.bashls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          bash = {
            enable = true,
            linting = true,
            shellcheck = { enable = true },
            globPattern = "*@(.sh|.inc|.bash|.command)",
          },
        },
      })

      -- Setup for Typescript language server
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
        single_file_support = true,
      })

      -- Setup for Python language server
      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic", -- Set to "off" for no type checking
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      -- Setup for JSON language server
      lspconfig.jsonls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
    end,
  },
}
