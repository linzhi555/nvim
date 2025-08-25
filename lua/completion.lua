local cmp = require("cmp")
 
cmp.setup({

    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    --completion = {
    --    autocomplete = false,
    --},
    preselect = cmp.PreselectMode.None ,
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-x>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false
        }),
        ["<C-j>"] = cmp.mapping(function()
            luasnip.jump(1)
        end, { "i", "s" }),
        ["<C-k>"] = cmp.mapping(function()
            luasnip.jump(-1)
        end, { "i", "s" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = 'vsnip' },
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
    }),

})

--vim.api.nvim_create_autocmd("BufEnter",{pattern="*.c",command="lua require('cmp').setup.buffer { enabled = false }"})
--vim.api.nvim_create_autocmd("BufEnter",{pattern="*.cpp",command="lua require('cmp').setup.buffer { enabled = false }"})
--vim.api.nvim_create_autocmd("BufEnter",{pattern="*.cc",command="lua require('cmp').setup.buffer { enabled = false }"})
--vim.api.nvim_create_autocmd("BufEnter",{pattern="*.h",command="lua require('cmp').setup.buffer { enabled = false }"})
