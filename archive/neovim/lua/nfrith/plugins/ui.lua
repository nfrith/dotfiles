return {
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons' },

  -- {
  --   'NvChad/nvim-colorizer.lua',
  --   event = 'User FilePost',
  --   opts = { user_default_options = { names = false } },
  --   config = function(_, opts)
  --     require('colorizer').setup(opts)
  --
  --     -- execute colorizer as soon as possible
  --     vim.defer_fn(function()
  --       require('colorizer').attach_to_buffer(0)
  --     end, 0)
  --   end,
  -- },

  -- {
  --   'nvim-tree/nvim-web-devicons',
  --   -- opts = function()
  --   --   return { override = require 'nvchad.icons.devicons' }
  --   -- end,
  --   config = function(_, opts)
  --     -- dofile(vim.g.base46_cache .. 'devicons')
  --     require('nvim-web-devicons').setup({
  --       color_icons = true
  --     })
  --   end,
  -- },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    config = function(_, opts)
      local hooks = require 'ibl.hooks'
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require('ibl').setup(opts)
    end,
  },

  -- { -- You can easily change to a different colorscheme.
  --   -- Change the name of the colorscheme plugin below, and then
  --   -- change the command in the config to whatever the name of that colorscheme is.
  --   --
  --   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   init = function()
  --     -- Load the colorscheme here.
  --     -- Like many other themes, this one has different styles, and you could load
  --     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --     vim.cmd.colorscheme 'tokyonight-moon'
  --
  --     -- You can configure highlights by doing something like:
  --     vim.cmd.hi 'Comment gui=none'
  --   end,
  -- },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    event = 'VeryLazy',
    config = function(_, opts)
      require('catppuccin').setup {
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = '',
          },
          telescope = {
            enabled = true,
          },
          mason = true,
        },
      }
    end,
    init = function()
      vim.cmd.colorscheme 'catppuccin-macchiato'
    end,
  },

  -- file managing , picker etc
  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
    opts = function()
      return require 'nfrith.configs.nvimtree'
    end,
    config = function(_, opts)
      require('nvim-tree').setup(opts)
    end,
  },
}
