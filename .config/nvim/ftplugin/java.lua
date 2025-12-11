local home = os.getenv("HOME")
local mason_root = vim.env.MASON and vim.env.MASON or vim.fn.stdpath('data') .. '/mason'
local eclipse_jdtls_path = mason_root .. '/packages/jdtls'
local equinox_launcher_path = vim.fn.glob(eclipse_jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", 1)
local lombok = eclipse_jdtls_path .. "/lombok.jar"

-- Safety check for equinox launcher
if equinox_launcher_path == "" then
  vim.notify("Equinox launcher not found", vim.log.levels.ERROR)
else
  vim.notify("Equinox launcher: " .. equinox_launcher_path, vim.log.levels.INFO)
end

-- Debug: check JDTLS installation
if vim.fn.isdirectory(eclipse_jdtls_path) == 0 then
  vim.notify("JDTLS directory not found: " .. eclipse_jdtls_path, vim.log.levels.ERROR)
else
  vim.notify("JDTLS path: " .. eclipse_jdtls_path, vim.log.levels.INFO)
end

-- Platform detection for cross-platform compatibility
local is_mac = vim.fn.has("mac") == 1
local is_linux = vim.fn.has("unix") == 1 and not is_mac
local is_windows = vim.fn.has("win32") == 1

-- Choose appropriate config directory based on platform
local config_dir
if is_mac then
	if vim.fn.has('arm64') == 1 then
		config_dir = eclipse_jdtls_path .. "/config_mac_arm"
	else
		config_dir = eclipse_jdtls_path .. "/config_mac"
	end
elseif is_windows then
	config_dir = eclipse_jdtls_path .. "/config_win"
else -- linux
	config_dir = eclipse_jdtls_path .. "/config_linux"
end

-- Platform-specific Java runtime paths
local java_runtimes = {}
if is_mac then
	java_runtimes = {
		{
			name = "JavaSE-17",
			-- Use Homebrew symlink for version stability
			path = "/usr/local/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
		},
		{
			name = "JavaSE-21",
			path = "/usr/local/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
		},
		{
			name = "JavaSE-25",
			path = "/usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home",
		},
	}
elseif is_linux then
	java_runtimes = {
		{
			name = "JavaSE-17",
			path = "/usr/lib/jvm/java-17-openjdk",
		},
		{
			name = "JavaSE-21",
			path = "/usr/lib/jvm/java-21-openjdk",
		},
		{
			name = "JavaSE-23",
			path = "/usr/lib/jvm/java-25-openjdk",
		},
	}
elseif is_windows then
	java_runtimes = {
		{
			name = "JavaSE-17",
			path = "C:\\Program Files\\Java\\jdk-17",
		},
		{
			name = "JavaSE-21",
			path = "C:\\Program Files\\Java\\jdk-21",
		},
		{
			name = "JavaSE-23",
			path = "C:\\Program Files\\Java\\jdk-23",
		},
	}
end

-- Debug output to help troubleshoot platform detection
vim.notify("Platform: mac=" .. tostring(is_mac) .. ", linux=" .. tostring(is_linux) .. ", windows=" .. tostring(is_windows))
vim.notify("Using config directory: " .. config_dir)

local java_debug_path = mason_root .. '/packages/java-debug-adapter'
local java_test_path = mason_root .. '/packages/java-test'

-- Debug: check if debug/test packages are installed
if vim.fn.isdirectory(java_debug_path) == 0 then
  vim.notify("Java debug adapter not found: " .. java_debug_path, vim.log.levels.WARN)
end
if vim.fn.isdirectory(java_test_path) == 0 then
  vim.notify("Java test package not found: " .. java_test_path, vim.log.levels.WARN)
end

local project_markers = vim.fs.find({ "gradlew", ".git", "mvnw", "build.gradle", "pom.xml", ".classpath" }, { upward = true })
local root_dir = project_markers[1] and vim.fs.dirname(project_markers[1]) or vim.fn.getcwd()

-- Inspired from github.com/IlyasYOY/dotfiles
local function matchInDir(file, pattern, plain)
	if plain == nil then
		plain = false
	end
	if pattern == nil then
		return false
	end

	local index = string.find(file, pattern, 1, plain)

	return index == 1
end

-- Inspired from github.com/IlyasYOY/dotfiles
local function findInDir(dir, pattern, plain)
	local targets = vim.fn.readdir(dir, function(file)
		if matchInDir(file, pattern, plain) then
			return 1
		end
	end)
	local target = targets[1]
	if not target then
		error(string.format("No %s target file was found", pattern))
	end
	return dir .. target
end

-- used by eclipse to determine what constitutes a workspace
local workspace_folder = home
	.. "/.local/java/nvim-jdtls-workspace-folder/"
	.. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

-- current project found using the root_marker as the dir for project specific data.
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- The on_attach function is used to set key maps after the language server
-- attaches to the current buffer
local on_attach = function(client, bufnr)
	require("jdtls").setup_dap({ hotcodereplace = "auto" })
	require("jdtls.setup").add_commands()
	require("dap.ext.vscode").load_launchjs()
	require("jdtls.dap").setup_dap_main_class_configs()
	-- local wk = require("which-key")
	-- wk.add({
	-- 	{ "<leader>j", group = "[j]dtls" }, -- group
	-- })
	vim.keymap.set("n", "<leader>jd", "<cmd>JdtUpdateDebugConfig<CR>", { buffer = bufnr, desc = "[j]dtls update [d]ebug config" })
	vim.keymap.set("n", "<leader>jc", "<cmd>JdtCompile full<CR>", { buffer = bufnr, desc = "[j]dtls [c]ompile full" })
	vim.keymap.set("n", "<leader>jl", "<cmd>JdtShowLogs<CR>", { buffer = bufnr, desc = "[j]dtls show [l]ogs" })
	vim.keymap.set("n", "<leader>jr", "<cmd>JdtRestart<CR>", { buffer = bufnr, desc = "[j]dtls [r]estart" })
	vim.keymap.set("n", "<leader>js", "<cmd>JdtSetRuntime<CR>", { buffer = bufnr, desc = "[j]dtls [s]et runtime" })
	vim.keymap.set("n", "<leader>ju", "<cmd>JdtUpdateConfig<CR>", { buffer = bufnr, desc = "[j]dtls [u]pdate config" })
	vim.keymap.set(
		"n",
		"<leader>ji",
		"<cmd>lua require'jdtls'.organize_imports()<CR>",
		{ buffer = bufnr, desc = "[j]dtls organize [i]mports" }
	)
	-- wk.add({
	-- 	{ "<leader>jx", group = "[j]dtls e[x]tract" }, -- group
	-- })
	vim.keymap.set(
		"n",
		"<leader>jxv",
		"<Cmd>lua require('jdtls').extract_variable()<CR>",
		{ buffer = bufnr, desc = "[j]dtls e[x]tract [v]ariable" }
	)
	vim.keymap.set(
		"v",
		"<leader>jxv",
		"<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
		{ buffer = bufnr, desc = "[j]dtls e[x]tract [v]ariable" }
	)
	vim.keymap.set(
		"n",
		"<leader>jxc",
		"<Cmd>lua require('jdtls').extract_constant()<CR>",
		{ buffer = bufnr, desc = "[j]dtls e[x]tract [c]onstant" }
	)
	vim.keymap.set(
		"v",
		"<leader>jxc",
		"<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
		{ buffer = bufnr, desc = "[j]dtls e[x]tract [c]onstant" }
	)
	vim.keymap.set(
		"v",
		"<leader>jxm",
		"<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
		{ buffer = bufnr, desc = "[j]dtls e[x]tract [m]ethod" }
	)
	-- wk.add({
	-- 	{ "<leader>jt", group = "[j]dtls [t]est" }, -- group
	-- })
	-- nvim-dap integration
	vim.keymap.set("n", "<leader>jtc", "<Cmd>lua require'jdtls'.test_class()<CR>", { buffer = bufnr, desc = "[j]dtls [t]est [c]lass" })
	vim.keymap.set(
		"n",
		"<leader>jtm",
		"<Cmd>lua require'jdtls'.test_nearest_method()<CR>",
		{ buffer = bufnr, desc = "[j]dtls [t]est nearest [m]ethod" }
	)
end

local bundles = {}
local debug_jar = vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1)
if debug_jar ~= "" then
  table.insert(bundles, debug_jar)
end

local test_jars = vim.fn.glob(java_test_path .. "/extension/server/*.jar", 1)
if test_jars ~= "" then
  -- Filter out empty strings from split result
  local test_jar_list = vim.split(test_jars, "\n")
  for _, jar in ipairs(test_jar_list) do
    if jar ~= "" then
      table.insert(bundles, jar)
    end
  end
end

-- Debug: log bundle count
if #bundles == 0 then
  vim.notify("No debug/test bundles found. Debug and test features may not work.", vim.log.levels.WARN)
else
  vim.notify("Loaded " .. #bundles .. " debug/test bundles", vim.log.levels.INFO)
end

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. lombok,
		"-jar",
		equinox_launcher_path,
		"-configuration",
		config_dir,
		"-data",
		workspace_folder,
	},
	flags = {
		debounce_text_changes = 80,
	},
	capabilities = capabilities,
	on_attach = on_attach, -- We pass our on_attach keybindings to the configuration map
	root_dir = root_dir,
	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	init_options = {
		bundles = bundles,
		extendedClientCapabilities = extendedClientCapabilities,
	},
	settings = {
		java = {
			format = {
				enabled = false,
				-- settings = {
				--   url = home .. "/.local/java/eclipse-java-google-style.xml",
				-- },
			},
			-- Additional formatting settings
			saveActions = {
				organizeImports = true,
			},
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" }, -- Use fernflower to decompile library code
			-- Specify any completion options
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
			},
			-- Specify any options for organizing imports
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			-- How code generation should act
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				hashCodeEquals = {
					useJava7Objects = true,
				},
				useBlocks = true,
			},
			-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
			-- And search for `interface RuntimeOption`
			-- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
			configuration = {
				runtimes = java_runtimes,
			},
		},
	},
	-- Note that eclipse.jdt.ls must be started with a Java version of 17 or higher
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	-- for the full list of options
}
require("jdtls").start_or_attach(config)
