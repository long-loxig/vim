local ascmini = require('core.ascmini')
local utils = require('core.utils')

local function find_project()
	local pwd = utils.current_root()
	require('telescope.builtin').find_files({cwd = pwd})
end

return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		-- Fuzzy Finder Algorithm which requires local dependencies to be built.
		-- Only load if `make` is available. Make sure you have the system
		-- requirements installed.
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			-- NOTE: If you are having trouble with this installation,
			--       refer to the README for telescope-fzf-native for more instructions.
			build = 'make',
			cond = function()
				return vim.fn.executable 'make' == 1
			end,
		},

		"kkharji/sqlite.lua",
		"nvim-telescope/telescope-frecency.nvim",
		"benfowler/telescope-luasnip.nvim",
	},

	cmd = 'Telescope',

	keys = {
		{'<c-n>', ':Telescope oldfiles<cr>', desc = 'find-old-files'},
		{'<c-p>', find_project, desc = 'find-project'},
	},

	config = function()
		local telescope = require('telescope')
		local actions = require("telescope.actions")

		require('telescope').setup {
			defaults = {
				mappings = {
					i = {
						['<C-u>'] = false,
						['<C-d>'] = false,
						['<esc>'] = actions.close,
					},
					n = {
						['<esc>'] = actions.close,
					}
				},
			},
		}

		pcall(require('telescope').load_extension, 'fzf')
		pcall(require('telescope').load_extension, 'luasnip')
		pcall(require('telescope').load_extension, 'frecency')
		-- telescope.load_extension('frecency')

		-- See `:help telescope.builtin`
		vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
		vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
		vim.keymap.set('n', '<leader>/', function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
					winblend = 10,
					previewer = false,
				})
		end, { desc = '[/] Fuzzily search in current buffer' })

		vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
		vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
		vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
		vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
		vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
		vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
	end,
}


