return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup({})

		vim.keymap.set("n", "<leader>a", function()
			local file = vim.fn.expand("%:p") -- Getfull path of current file
			harpoon:list():add()
			print("📌 Added to harpoon: " .. file)
		end)

		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		-- vim.keymap.set("n", "<M-q>", function()
		-- 	harpoon:list():select(1)
		-- end)
		--
		-- vim.keymap.set("n", "<M-w>", function()
		-- 	harpoon:list():select(2)
		-- end)
		--
		-- vim.keymap.set("n", "<M-e>", function()
		-- 	harpoon:list():select(3)
		-- end)
		--
		-- vim.keymap.set("n", "<M-r>", function()
		-- 	harpoon:list():select(4)
		-- end)
		--
		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<D-k>", function()
			harpoon:list():prev()
		end)

		vim.keymap.set("n", "<D-j>", function()
			harpoon:list():next()
		end)
	end,
}
