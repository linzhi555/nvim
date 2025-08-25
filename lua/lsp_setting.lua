local nvim_lsp = require("lspconfig")
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
vim.diagnostic.config({ virtual_text = false, underline = false })

local on_attach = function(_, bufnr)
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gs", vim.lsp.buf.document_symbol, opts)
    vim.keymap.set("n", "gn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<space>f", vim.lsp.buf.format, opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)


-- the language server that don not need to configure
local servers = { "pyright", "gopls", "bashls", "rust_analyzer",
    "html", "cssls", "vimls", "jdtls" }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup({
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

nvim_lsp.denols.setup {
    on_attach = on_attach,
    root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
}

nvim_lsp.ts_ls.setup {
    on_attach = on_attach,
    root_dir = nvim_lsp.util.root_pattern("package.json"),
    single_file_support = false
}

-- for vue develop
--nvim_lsp.volar.setup{
--    on_attach = on_attach,
--    capabilities = capabilities,
--    init_options = {
--        typescript = {
--        --tsdk = '/path/to/.npm/lib/node_modules/typescript/lib'
--        -- Alternative location if installed as root:
--        tsdk = '/usr/local/lib/node_modules/typescript/lib'
--        }
--    },
--    filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'}
--}

-- c/c++ for c/c++ develop

function setup_clangd()
    nvim_lsp.clangd.setup {
        cmd = { "clangd", "--query-driver=/usr/bin/c++", "--background-index=true" },
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = nvim_lsp.util.root_pattern('.clangd')
    }
end

local use_cland = true
if use_cland then
    setup_clangd()
end

function reload_clangd()
    setup_clangd()
    --start the lsp by reload the buffer
    vim.cmd("LspStart")
end

if not use_cland then
    vim.api.nvim_create_user_command('LzqUseClangd', reload_clangd, {})
end


-- lua for neovim lua, add vim runtime path
local luaLib = vim.api.nvim_get_runtime_file("", true)
nvim_lsp.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = luaLib,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },

})
