return {
    -- Manages installation of language servers (e.g. gopls) for you,
    -- so you don't need them on your system PATH manually.
    {
        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            -- Servers mason will ensure are installed. mason-lspconfig
            -- automatically calls vim.lsp.enable() for each of these
            -- once installed, using nvim-lspconfig's default config.
            --
            -- rust_analyzer is deliberately NOT listed here -- rustaceanvim
            -- (below) owns launching/configuring it instead, to avoid
            -- double-attaching a second client to Rust buffers.
            ensure_installed = { "gopls", "pyright", "ts_ls" },
        },
    },

    -- Ships default per-server configs (e.g. gopls) for Neovim's native
    -- LSP client. On 0.11+, no manual .setup() calls are needed -- servers
    -- are turned on with vim.lsp.enable(), which mason-lspconfig does for
    -- us above.
    {
        "neovim/nvim-lspconfig",
        config = function ()
            -- Show diagnostics (errors/warnings) as virtual text and
            -- underline, which is what actually gives you the "red
            -- squiggle" error highlighting under bad code.
            vim.diagnostic.config({
                virtual_text = true,
                underline = true,
                severity_sort = true,
            })

            -- Handy LSP keymaps, set up once an LSP attaches to a buffer.
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function (args)
                    local opts = { buffer = args.buf }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                end,
            })
        end,
    },

    -- Rust gets its own plugin instead of the plain mason-lspconfig path:
    -- rustaceanvim launches and configures rust-analyzer itself (better
    -- handling of cargo workspaces, runnables, etc.) and fires the same
    -- LspAttach autocmd above, so the standard keymaps still apply.
    {
        "mrcjkb/rustaceanvim",
        version = "^6", -- pin to the latest major version
        lazy = false,   -- rustaceanvim itself sets up lazy-loading via ft = "rust"
    },
}
