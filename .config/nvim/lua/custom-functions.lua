local M = {}

--- Check if a file exists and is readable
--- @param path string Path to check
--- @return boolean True if file exists and is readable
function M.file_exists(path)
    return vim.fn.filereadable(path) == 1
end

return M