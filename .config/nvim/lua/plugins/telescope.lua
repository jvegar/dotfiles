local function find_project_root()
  local markers = { ".git", "Makefile", "package.json" }
  for _, marker in ipairs(markers) do
    local root = vim.fs.find(marker, {
      upward = true,
      stop = vim.env.HOME,
      path = vim.fn.expand("%:p:h"),
    })[1]
    if root then
      return vim.fs.dirname(root)
    end
  end
  return vim.loop.cwd()
end

return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader><leader>",
        "<cmd>Telescope find_files<cr>",
        desc = "Find files (includes hidden and ignored)",
      },
      { "<leader>lb", "<cmd>Telescope buffers<cr>", desc = "List open buffers" },
      { "<leader>rf", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in Current Buffer" },
      { "<leader>lg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>ld", "<cmd>Telescope diagnostics<cr>", desc = "List Diagnostics" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            ".hg/",
            ".svn/",
            "__pycache__/",
            "%.egg-info/",
            "%.egg-cache/",
          },
          hidden = true,
          no_ignore = true,
          no_ignore_parent = true,
        },
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = true,
            no_ignore_parent = true,
          },
          live_grep = {
            additional_args = function(opts)
              return { "--hidden", "--no-ignore" }
            end,
          },
          diagnostics = {
            root_dir = find_project_root(),
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      require("telescope").load_extension("ui-select")
    end,
  },
}
