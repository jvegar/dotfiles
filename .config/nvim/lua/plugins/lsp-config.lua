local fn = vim.fn

local function buildTags()
  local cwd = fn.getcwd()
  if string.find(cwd, "repositories") then
    return { "-tags=build integration && !unit" }
  end

  return { "-tags=" }
end

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
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      -- Setup fo Clangd language server 
      lspconfig.clangd.setup({
        capabilities = capabilities,
        cmd = { "clangd", "--background-index" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
      })
      -- Setup for Go language server
      lspconfig.gopls.setup({
        capabilities = capabilities,
        settings = {
          gopls = {
            buildFlags = buildTags(),
          },
        },
        staticcheck = true,
      })
      -- Setup for TOML language server
      lspconfig.taplo.setup({
        capabilities = capabilities,
      })
      -- Setup for Lua language server
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
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
        cmd = { "typescript-language-server", "--stdio" },
        settings = {
          tsserver = {
            filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
            root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json"),
          },
        },
      })

      -- Keymaps for LSP functionality
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find references" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
    end,
  },
}

