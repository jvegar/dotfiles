return {
  "yetone/avante.nvim",
  enabled = false,
  build = function()
    -- conditionally use the correct build system for the current OS
    if vim.fn.has("win32") == 1 then
      return "powershell -ExecutionPolicy Bypass -File build.ps1 -BuildFromSource false"
    else
      return "make"
    end
  end,
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never! 
  --@module 'avante'
  --@type avante.Config
  opts = {
    --provider = "openai",
    --providers = {
    --  openai = {
    --    endpoint = "https://api.openai.com/v1",
    --    model = "gpt-4o",
    --    timeout = 20000, -- Timeout in miliseconds
    --    extra_request_body = {
    --      temperature = 0.75,
    --      max_tokens = 20480,
    --    },
    --  },
    --},
    provider = "openrouter",
    providers = {
      openrouter = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        model = "deepseek/deepseek-r1",
        api_key_name= "OPENROUTER_API_KEY",
        timeout = 20000, -- Timeout in miliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 1453,
        },
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- The below dependencies are optional,
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- for completion provider nvim-cmp
    "ibhagwan/fzf-lua", -- for file_selector provider fzf-lua
    "stevearc/dressing.nvim", -- for input provider dressing
    "folke/snacks.nvim", -- for input provider snacks
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for copilot provider
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        filetypes = { 'markdown', 'md' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
