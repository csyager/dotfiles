return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8', -- Specifies a stable release branch
    dependencies = { 
      'nvim-lua/plenary.nvim',
      { 'nvim-tree/nvim-web-devicons', enabled = true }, -- Adds file icons
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' } -- Speeds up sorting
    },
    config = function()
      local telescope = require('telescope')
      
      -- Basic configuration setup
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false, -- Clears the input prompt line
              ['<C-d>'] = false, -- Default scroll preview page down
            },
          },
          file_ignore_patterns = {
              "node_modules/"
          },
        },
      })

      -- Load extensions if installed
      pcall(telescope.load_extension, 'fzf')

      -- Keymaps for core Telescope functions
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope Find Files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope Live Grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope Buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope Help Tags' })
    end
  }
}
