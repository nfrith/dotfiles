local map = vim.keymap.set

map('i', '<C-b>', '<ESC>^i', { desc = 'move beginning of line' })
map('i', '<C-e>', '<End>', { desc = 'move end of line' })
map('i', '<C-h>', '<Left>', { desc = 'move left' })
map('i', '<C-l>', '<Right>', { desc = 'move right' })
map('i', '<C-j>', '<Down>', { desc = 'move down' })
map('i', '<C-k>', '<Up>', { desc = 'move up' })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>noh<CR>', { desc = 'clears all highlights in the current buffer' })
-- map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'clear only the highlights generated by the last search operation' })

map('n', '<C-h>', '<C-w>h', { desc = 'switch window left' })
map('n', '<C-l>', '<C-w>l', { desc = 'switch window right' })
map('n', '<C-j>', '<C-w>j', { desc = 'switch window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'switch window up' })
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

map('n', '<C-s>', '<cmd>w<CR>', { desc = 'file save' })
map('n', '<C-c>', '<cmd>%y+<CR>', { desc = 'file copy whole' })

map('n', '<leader>n', '<cmd>set nu!<CR>', { desc = 'toggle line number' })
map('n', '<leader>rn', '<cmd>set rnu!<CR>', { desc = 'toggle relative number' })
map('n', '<leader>ch', '<cmd>NvCheatsheet<CR>', { desc = 'toggle nvcheatsheet' })

-- map('n', '<leader>fm', function()
--   require('conform').format { lsp_fallback = true }
-- end, { desc = 'format files' })

-----------------------------------------------------------------
---------------------------- ocs52 ------------------------------
-----------------------------------------------------------------
map('n', '<leader>c', require('osc52').copy_operator, { desc = 'copy the given text to clipboard', expr = true })
map('n', '<leader>cc', '<leader>c_', { desc = 'copy current line', remap = true})
map('v', '<leader>c', require('osc52').copy_visual, { desc = 'copy the current selection'})

-----------------------------------------------------------------
------------------ Diagnostic keymaps ---------------------------
-----------------------------------------------------------------
map('n', '<leader>dj', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
map('n', '<leader>dk', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
map('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
map('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-----------------------------------------------------------------
------------------------- tabufline -----------------------------
-----------------------------------------------------------------
-- map('n', '<leader>b', '<cmd>enew<CR>', { desc = 'buffer new' })
--
-- map('n', '<tab>', function()
--   require('nvchad.tabufline').next()
-- end, { desc = 'buffer goto next' })
--
-- map('n', '<S-tab>', function()
--   require('nvchad.tabufline').prev()
-- end, { desc = 'buffer goto prev' })
--
-- map('n', '<leader>x', function()
--   require('nvchad.tabufline').close_buffer()
-- end, { desc = 'buffer close' })

-----------------------------------------------------------------
------------------------ Comment --------------------------------
-----------------------------------------------------------------
map('v', '<C-/>', "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = 'comment toggle' })
map('n', '<C-/>', "<cmd>lua require('Comment.api').toggle.linewise()<CR>", { desc = 'comment toggle' })

-----------------------------------------------------------------
------------------------ nvimtree -------------------------------
-----------------------------------------------------------------
map('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { desc = 'nvimtree toggle window' })
map('n', '<leader>e', '<cmd>NvimTreeFocus<CR>', { desc = 'nvimtree toggle window' })

-----------------------------------------------------------------
--------------------------- telescope ---------------------------
-----------------------------------------------------------------
-- map('n', '<leader>fw', '<cmd>Telescope live_grep<CR>', { desc = 'telescope live grep' })
-- map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'telescope find buffers' })
-- map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'telescope help page' })
-- map('n', '<leader>ma', '<cmd>Telescope marks<CR>', { desc = 'telescope find marks' })
-- map('n', '<leader>fo', '<cmd>Telescope oldfiles<CR>', { desc = 'telescope find oldfiles' })
-- map('n', '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { desc = 'telescope find in current buffer' })
-- map('n', '<leader>cm', '<cmd>Telescope git_commits<CR>', { desc = 'telescope git commits' })
-- map('n', '<leader>gt', '<cmd>Telescope git_status<CR>', { desc = 'telescope git status' })
-- ap('n', '<leader>pt', '<cmd>Telescope terms<CR>', { desc = 'telescope pick hidden term' })
-- map('n', '<leader>th', '<cmd>Telescope themes<CR>', { desc = 'telescope nvchad themes' })
-- map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'telescope find files' })
-- map('n', '<leader>fa', '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>', { desc = 'telescope find all files' })

-----------------------------------------------------------------
--------------------- telescope (kickstart) ---------------------
-----------------------------------------------------------------
-- See `:help telescope.builtin`
local builtin = require 'telescope.builtin'
map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
map('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
map('n', '<leader>s<C-t>', builtin.git_files, { desc = '[S]earch [G]it [T]racked files' })
map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
map('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

-- Shortcut for searching your Neovim configuration files
map('n', '<leader>sn', function()
  local search_dirs = {
    vim.fn.stdpath 'config',
    vim.fn.expand '~/dotfiles/neovim',
  }

  -- builtin.find_files { cwd = vim.fn.stdpath 'config' }
  builtin.find_files { search_dirs = search_dirs }
end, { desc = '[S]earch [N]eovim files' })

-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

-----------------------------------------------------------------
---------------------------- copilot ----------------------------
-----------------------------------------------------------------
map('n', '<leader>ah', function()
  local actions = require 'CopilotChat.actions'
  require('CopilotChat.integrations.telescope').pick(actions.help_actions())
end, { desc = 'CopilotChat - Help actions' })

map('n', '<leader>ap', function()
  local actions = require 'CopilotChat.actions'
  require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
end, { desc = 'CopilotChat - prompt actions' })

map('x', '<leader>ae', '<cmd>CopilotChatExplain<cr>', { desc = 'CopilotChat - Explain Code' })

map('n', '<leader>ai', function()
  local input = vim.fn.input 'Ask Copilot: '
  if input ~= '' then
    vim.cmd('CopilotChat ' .. input)
  end
end, { desc = 'CopilotChat - Ask input' })

-----------------------------------------------------------------
-------------------------- terminal  ----------------------------
-----------------------------------------------------------------
map('t', '<C-x>', '<C-\\><C-N>', { desc = 'terminal escape terminal mode' })

-- new terminals
map('n', '<leader>h', function()
  require('nvchad.term').new { pos = 'sp' }
end, { desc = 'terminal new horizontal term' })

map('n', '<leader>v', function()
  require('nvchad.term').new { pos = 'vsp' }
end, { desc = 'terminal new vertical window' })

-- toggleable
map({ 'n', 't' }, '<A-v>', function()
  require('nvchad.term').toggle { pos = 'vsp', id = 'vtoggleTerm' }
end, { desc = 'terminal toggleable vertical term' })

map({ 'n', 't' }, '<A-h>', function()
  require('nvchad.term').toggle { pos = 'sp', id = 'htoggleTerm' }
end, { desc = 'terminal new horizontal term' })

map({ 'n', 't' }, '<A-i>', function()
  require('nvchad.term').toggle { pos = 'float', id = 'floatTerm' }
end, { desc = 'terminal toggle floating term' })

-- whichkey
map('n', '<leader>wK', '<cmd>WhichKey <CR>', { desc = 'whichkey all keymaps' })
-- map('n', '<leader>wk', function()
--   vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ')
-- end, { desc = 'whichkey query lookup' })

-- blankline
map('n', '<leader>cc', function()
  local config = { scope = {} }
  config.scope.exclude = { language = {}, node_type = {} }
  config.scope.include = { node_type = {} }
  local node = require('ibl.scope').get(vim.api.nvim_get_current_buf(), config)

  if node then
    local start_row, _, end_row, _ = node:range()
    if start_row ~= end_row then
      vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
      vim.api.nvim_feedkeys('_', 'n', true)
    end
  end
end, { desc = 'blankline jump to current context' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
