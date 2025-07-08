return {
  cmd = {
    "typescript-language-server", "--stdio"
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    ".git",
    "package.json",
    "tsconfig.json",
    "jsconfig.json"
  },
  workspace_required = true,
  --settings = {
  --  Lua = {
  --    diagnostics = {
  --      globals = { "vim" }
  --    }
  --  }
  --},
  single_file_support = true,
  log_level = vim.lsp.protocol.MessageType.Warning,
}
