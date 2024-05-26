local opt = vim.opt
local o = vim.o
local g = vim.g

-------------------------------------- globals -----------------------------------------
g.toggle_theme_icon = "   "
g.have_nerd_font = true -- Set to true if you have a Nerd Font installed and selected in the terminal

-------------------------------------- options ------------------------------------------
-- See `:help vim.opt`, For more options, you can see `:help option-list`
-----------------------------------------------------------------------------------------

o.laststatus = 3
o.showmode = false -- Don't show the mode, since it's already in the status line

-- Sync clipboard between OS and Neovim.
-- Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
-- o.clipboard = "unnamedplus"

-- vim.g.clipboard = {
--   name = 'OSC 52',
--   copy = {
--     ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
--     ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
--   },
--   paste = {
--     ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
--     ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
--   },
-- }

local function copy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end

local function paste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end

g.clipboard = {
  name = 'osc52',
  copy = {['+'] = copy, ['*'] = copy},
  paste = {['+'] = paste, ['*'] = paste},
}

-- vim.opt.clipboard = 'unnamed'
-- vim.g.clipboard = {
--     name = "kittyClipboard",
--     copy = {
--         ["*"] = {"kitten clipboard"},
--         ["+"] = {"kitten clipboard"},
--     },
--     paste = {
--         ["*"] = { "kitty","+kitten", "clipboard", "--get-clipboard" },
--         ["+"] = { "kitty","+kitten", "clipboard", "--get-clipboard" },
--     },
--     cache_enabled = 1,
-- }

o.cursorline = true
o.cursorlineopt = "number"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2
opt.breakindent = true

opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a" -- Enable mouse mode, can be useful for resizing splits for example!

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = false
opt.relativenumber = true

-- disable nvim intro
opt.shortmess:append 'sI'

o.signcolumn = 'yes'
o.splitbelow = true
o.splitright = true
o.timeoutlen = 300 -- Decrease mapped sequence wait time; displays which-key popup sooner
o.undofile = true
o.updatetime = 250 -- interval for writing swap file to disk, also used by gitsigns

-- Sets how neovim will display certain whitespace characters in the editor.
-- See `:help 'list'`
-- and `:help 'listchars'`
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.inccommand = 'split' -- Preview substitutions live, as you type!
opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
opt.hlsearch = true -- Set highlight on search
opt.whichwrap:append "<>[]hl" -- go to previous/next line with h,l,left arrow and right arrow when cursor reaches end/beginning of line
opt.swapfile = false

-- g.mapleader = " "

-- disable some default providers
-- g["loaded_node_provider"] = 0
g["loaded_python3_provider"] = 0
g["loaded_perl_provider"] = 0
g["loaded_ruby_provider"] = 0

-- add binaries installed by mason.nvim to path
-- local is_windows = vim.fn.has("win32") ~= 0
-- vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH
