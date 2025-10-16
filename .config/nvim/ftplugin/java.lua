-- ftplugin/java.lua

local ok, jdtls = pcall(require, "jdtls")
if not ok then
	vim.notify("nvim-jdtls not found", vim.log.levels.ERROR)
	return
end

-- Derive project root
local root_markers = { "gradlew", "mvnw", ".git", "build.gradle", "pom.xml" }
local root_dir = vim.fs.root(vim.api.nvim_buf_get_name(0), root_markers)
if not root_dir then
	-- fallback, maybe the cwd
	root_dir = vim.loop.cwd()
end

-- Derive a workspace directory unique per project
local project_name = vim.fs.basename(root_dir)
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

-- Command to start jdtls (you installed via Homebrew, so `jdtls` should be on PATH)
local cmd = { "jdtls" }

-- Enable Lombok support
local lombok = vim.fn.expand("$HOME/.local/share/java/lombok.jar")
if vim.fn.filereadable(lombok) == 1 then
  table.insert(cmd, string.format("-javaagent:%s", lombok))
  vim.notify("Lombok support enabled", vim.log.levels.INFO)
else
  vim.notify("Lombok jar not found at " .. lombok, vim.log.levels.WARN)
end

local config = {
	cmd = cmd,
	root_dir = root_dir,
	workspace_dir = workspace_dir,
	settings = {
		java = {
			-- your eclipse.jdt.ls settings here
			-- e.g.:
			-- completion = { favoriteStaticMembers = { "org.junit.Assert.*" }, ... },
			-- sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
			-- etc.

			-- Lombok support configuration
			configuration = {
				runtimes = {
					{
						name = "JavaSE-17",
						path = vim.fn.system("java -XshowSettings:properties -version 2>&1 | grep 'java.home' | awk '{print $3}'"):gsub("\n", ""),
					},
				},
			},
		},
	},
	init_options = {
		bundles = {}, -- add Java debug/test bundles if desired
	},
	-- optional: override `on_attach`, `capabilities`, etc.
	on_attach = function(client, bufnr)
		-- your keymaps for Java LSP
		local opts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		-- etc.
	end,
}

-- Finally, start or attach
jdtls.start_or_attach(config)
