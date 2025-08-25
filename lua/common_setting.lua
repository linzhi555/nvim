-- view setting
if vim.fn.has 'nvim-0.10' == 1 then
    vim.cmd [[colorscheme vim]]
end
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#004100", fg = "#FFFFFF" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#101010", fg = "#FFFFFF" })
vim.api.nvim_set_hl(0, "Visual", { bg = "#404040" })
vim.api.nvim_set_hl(0, "Folded", { bg = "#404040" })
vim.api.nvim_set_hl(0, "Folded", { bg = "#404040" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#414141", fg = "#FFFFFF" })

vim.o.number = true
function tn()
    vim.o.number = not vim.o.number
    --    if vim.o.number then
    --        vim.o.relativenumber = true
    --    else
    --        vim.o.relativenumber = false
    --    end
end

-- set nohlseach
vim.o.hlsearch = true

-- show unvisible char
vim.o.list = true

--vim.o.syntax = false

-- indent setting
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.expandtab = true
vim.cmd [[autocmd FileType go setlocal noexpandtab ]]

-- split window setting
vim.o.splitright = true
vim.o.splitbelow = true

---- make me know which line focused
--vim.o.cul = true
--vim.cmd [[highlight CursorLine guibg=None cterm=underline gui=underline]]

-- y and p use system clipboard
vim.cmd [[set clipboard+=unnamedplus]]

-- key map

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


map('n', ';', ':', {})
map('n', '<space>k', ":bn<cr>", {})
map('n', '<space>j', ":bp<cr>", {})

map('n', '<space>n', ":cn<cr>", {})
map('n', '<space>N', ":cp<cr>", {})
map('n', '<space>o', ":copen<cr>", {})

map('n', '<space>w', ':bdelete<cr>', {})

map('n', '<space>m', ':buffers<cr>:b<space>', {})
map('n', '<space>x', ':lua ', {})
map('n', '<space>1', ':botright term ', {})
