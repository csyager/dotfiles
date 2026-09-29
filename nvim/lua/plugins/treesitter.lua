return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            -- Let nvim-treesitter use its own default install directory
            -- (stdpath("data") .. "/site"), which Neovim already puts on
            -- runtimepath. Overriding this to a custom path caused
            -- checkhealth's "not in runtimepath" error and made query
            -- resolution (locals/folds/indents/injections) unreliable.
            require("nvim-treesitter").setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "go", "gomod", "gowork", "gosum" },
                sync_install = false,

                -- Automatically install missing parsers when entering a buffer
                auto_install = true,
            })

            -- On the `main` branch of nvim-treesitter, setup() no longer
            -- starts highlighting by itself -- start it per-buffer here.
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function (args)
                    local ok = pcall(vim.treesitter.start, args.buf)
                    if ok then
                        vim.bo[args.buf].syntax = "off"
                    end
                end,
            })
        end
    }
}
