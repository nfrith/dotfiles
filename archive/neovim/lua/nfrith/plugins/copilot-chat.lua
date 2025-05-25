local prompts = {
  -- Code related prompts
  Explain = 'Please explain how the following code works.',
  Review = 'Please review the following code and provide suggestions for improvement.',
  Tests = 'Please explain how the selected code works, then generate unit tests for it.',
  Refactor = 'Please refactor the following code to improve its clarity and readability.',
  FixCode = 'Please fix the following code to make it work as intended.',
  FixError = 'Please explain the error in the following text and provide a solution.',
  BetterNamings = 'Please provide better names for the following variables and functions.',
  Documentation = 'Please provide documentation for the following code.',
  SwaggerApiDocs = 'Please provide documentation for the following API using Swagger.',
  SwaggerJsDocs = 'Please write JSDoc for the following API using Swagger.',
  -- Text related prompts
  Summarize = 'Please summarize the following text.',
  Spelling = 'Please correct any grammar and spelling errors in the following text.',
  Wording = 'Please improve the grammar and wording of the following text.',
  Concise = 'Please rewrite the following text to make it more concise.',
}

return {
  {
    'robitx/gp.nvim',
    event = 'VeryLazy',
    config = function()
      -- require('gp').setup()

      -- or setup with your own config (see Install > Configuration in Readme)
      local config = {
        openai_api_key = os.getenv 'OPENAI_API_KEY',
        agents = {
          {
            name = 'ChatGPT3-5',
            chat = false,
            command = false,
          },
          {
            name = 'ChatGPT4',
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = 'gpt-4-turbo', temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = 'You are a general AI assistant.\n\n'
              .. 'The user provided the additional info about how they would like you to respond:\n\n'
              .. "- If you're unsure don't guess and say you don't know instead.\n"
              .. '- Ask question if you need clarification to provide better answer.\n'
              .. '- Think deeply and carefully from first principles step by step.\n'
              .. '- Zoom out first to see the big picture and then zoom in to details.\n'
              .. '- Use Socratic method to improve your thinking and coding skills.\n'
              .. "- Don't elide any code from your output if the answer requires coding.\n"
              .. "- Take a deep breath; You've got this!\n",
          },
        },
        chat_user_prefix = 'GOAL:',
        template_selection = 'CONTEXT: \n\n{{selection}}\n\n{{command}}',
        hooks = {
          AllBuffersChatNew = function(gp, params)
            vim.api.nvim_command('%' .. gp.config.cmd_prefix .. 'ChatNew')

            local all_text = ''
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) then
                local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                all_text = all_text .. table.concat(lines, '\n') .. '\n'
              end
            end

            -- Check if concatenated text exceeds token limit
            local token_limit = gp.config.token_limit or 10096 -- Set a default limit if not configured
            if #all_text > token_limit then
              all_text = string.sub(all_text, 1, token_limit) -- Truncate to avoid exceeding limit
              vim.api.nvim_err_writeln 'Warning: Concatenated text exceeds token limit. Truncating...'
            end

            -- Set the concatenated text in the new chat buffer
            vim.api.nvim_buf_set_lines(0, 0, -1, false, { all_text })

            -- Execute the chat command in the new buffer
            vim.api.nvim_command('%' .. gp.config.cmd_prefix .. 'ChatNew')
          end,

          UseCurrentBufferChatNew = function(gp, _)
            vim.api.nvim_command('%' .. gp.config.cmd_prefix .. 'ChatNew')
          end,
        },
      }
      require('gp').setup(config)

      local function keymapOptions(desc)
        return {
          noremap = true,
          silent = true,
          nowait = true,
          desc = 'GPT prompt ' .. desc,
        }
      end

      -- Chat commands
      vim.keymap.set({ 'n' }, '<leader>an', '<cmd>GpChatNew<cr>', keymapOptions 'New Chat')
      vim.keymap.set({ 'n' }, '<leader>ap', '<cmd>GpUseCurrentBufferChatNew<cr>', keymapOptions 'Paste into new Chat')
      vim.keymap.set({ 'n' }, '<leader>ac', '<cmd>GpChatToggle split<cr>', keymapOptions 'Toggle Chat')
      vim.keymap.set({ 'n' }, '<leader>af', '<cmd>GpChatFinder<cr>', keymapOptions 'Chat Finder')
      vim.keymap.set({ 'n', 'i', 'v', 'x' }, '<C-g>s', '<cmd>GpStop<cr>', keymapOptions 'Stop')
      vim.keymap.set({ 'n', 'i', 'v', 'x' }, '<C-g>n', '<cmd>GpNextAgent<cr>', keymapOptions 'Next Agent')

      -- copied from github
      vim.keymap.set('v', '<leader>ar', ":<C-u>'<,'>GpRewrite<cr>", keymapOptions 'Visual Rewrite')
      vim.keymap.set('v', '<leader>aa', ":<C-u>'<,'>GpAppend<cr>", keymapOptions 'Visual Append (after)')
      vim.keymap.set('v', '<leader>ap', ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions 'Paste into latest chat')
      vim.keymap.set('v', '<leader>ab', ":<C-u>'<,'>GpPrepend<cr>", keymapOptions 'Visual Prepend (before)')
      vim.keymap.set('v', '<leader>ai', ":<C-u>'<,'>GpImplement<cr>", keymapOptions 'Implement selection')
      -- vim.keymap.set({ 'n', 'i' }, '<leader>ap', '<cmd>GpPopup<cr>', keymapOptions 'Popup')
    end,
  },

  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({})
  --   end,
  -- },
  --
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   branch = "canary",
  --   event = "VeryLazy",
  --   dependencies = {
  --     { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
  --     { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  --     { "nvim-telescope/telescope.nvim" },
  --   },
  --   opts = {
  --     debug = true, -- Enable debug logging
  --     question_header = "## User ",
  --     answer_header = "## Copilot ",
  --     error_header = "## Error ",
  --     separator = " ", -- Separator to use in chat
  --     prompts = prompts,
  --     auto_follow_cursor = false, -- Don't follow the cursor after getting response
  --     show_help = true, -- Show help in virtual text, set to true if that's 1st time using Copilot Chat
  --     context = 'buffers',
  --     window = {
  --         layout = 'float',
  --         relative = 'cursor',
  --         width = 1,
  --         height = 0.4,
  --         row = 1
  --     }
  --   },
  --   config = function(_, opts)
  --     local chat = require("CopilotChat")
  --     local select = require("CopilotChat.select")
  --     -- Use unnamed register for the selection
  --     opts.selection = select.unnamed
  --
  --     -- Override the git prompts message
  --     opts.prompts.Commit = {
  --       prompt = "Write commit message for the change with commitizen convention",
  --       selection = select.gitdiff,
  --     }
  --     opts.prompts.CommitStaged = {
  --       prompt = "Write commit message for the change with commitizen convention",
  --       selection = function(source)
  --         return select.gitdiff(source, true)
  --       end,
  --     }
  --
  --     chat.setup(opts)
  --
  --     vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
  --       chat.ask(args.args, { selection = select.visual })
  --     end, { nargs = "*", range = true })
  --
  --     -- Inline chat with Copilot
  --     vim.api.nvim_create_user_command("CopilotChatInline", function(args)
  --       chat.ask(args.args, {
  --         selection = select.visual,
  --         window = {
  --           layout = "float",
  --           relative = "cursor",
  --           width = 1,
  --           height = 0.4,
  --           row = 1,
  --         },
  --       })
  --     end, { nargs = "*", range = true })
  --
  --     -- Custom buffer for CopilotChat
  --     vim.api.nvim_create_autocmd("BufEnter", {
  --       pattern = "copilot-*",
  --       callback = function()
  --         vim.opt_local.relativenumber = true
  --         vim.opt_local.number = true
  --
  --         -- Get current filetype and set it to markdown if the current filetype is copilot-chat
  --         local ft = vim.bo.filetype
  --         if ft == "copilot-chat" then
  --           vim.bo.filetype = "markdown"
  --         end
  --       end,
  --     })
  --   end,
  --   keys = {
  --   },
  -- }
}
