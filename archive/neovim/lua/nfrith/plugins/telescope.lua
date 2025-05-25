return {

  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    branch = '0.1.x',
    dependencies = {
      { 'nvim-lua/plenary.nvim', lazy = true},
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        lazy = true,
        enabled = vim.fn.executable "make" == 1,
        build = "make",
      },
      { "nvim-treesitter/nvim-treesitter" },
      -- { 'nvim-telescope/telescope-ui-select.nvim' },
      -- { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local telescope = require 'telescope'
      telescope.setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      -- Enable Telescope extensions if they are installed
      local telescope_status_ok = pcall(require('telescope').load_extension, 'fzf')
      if not telescope_status_ok then
        vim.notify("Telescope 'fzf' extension not found.")
      end
      -- pcall(require('telescope').load_extension, 'ui-select')

    end,
  }

}
