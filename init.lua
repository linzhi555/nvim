vim.cmd [[

"" windows specific configs
if has('win32') || has('win64')
  set shell=bash
  set shellcmdflag=-c
  let g:python3_host_prog = "python"
endif



function! g:Sdf()
    echo "welcome to lzq'nvim"
endfunction


call Sdf()

" 定义一个函数来查找函数定义
function! FindFunctionDefinition()
    " 保存当前光标位置
    let save_cursor = getpos(".")
    " 向上搜索函数定义
    let pattern = '^\w\+\s\+.*\w\+\s*('
    let found = search(pattern, 'bWn')
    " 如果找到了匹配的函数定义
    if found > 0
        " 跳转到匹配的位置
        execute "normal! " . found . "G"
    else
        " 如果没有找到，恢复光标位置
        call setpos('.', save_cursor)
        echo "未找到函数定义"
    endif
endfunction
" 映射快捷键来调用这个函数
nnoremap <space>fd :call FindFunctionDefinition()<CR>

" ====================
" 基础设置
" ====================
set nocompatible            " 禁用兼容模式（启用 Vim 特性）
set encoding=utf-8          " 文件编码
set fileencodings=utf-8,gbk " 自动识别文件编码
set nobackup                " 不生成备份文件
set noswapfile              " 不生成交换文件
syntax on                   " 语法高亮
filetype plugin indent on   " 文件类型检测+插件+自动缩进

" ====================
" 界面优化
" ====================
colorscheme evening
set guifont=Consolas:h10    " 字体设置（推荐 Cascadia Code/Monaco/Consolas）
set number                  " 显示行号
set hlsearch
set list                    " 开启 list 模式以显示不可见字符
set listchars=tab:▸\ ,trail:·" 自定义符号显示规则

"set relativenumber          " 相对行号（可选）
set cursorline              " 高亮当前行
set showcmd                 " 显示输入命令
set wildmenu                " 命令补全菜单
set tabpagemax=20           " 标签页最多显示20个

" ====================
" 编辑体验
" ====================
set expandtab               " 用空格代替制表符
set tabstop=4               " Tab显示为4空格
set shiftwidth=4            " 自动缩进4空格
set softtabstop=4           " 退格删除4空格
set autoindent              " 自动缩进
set smartindent             " 智能缩进
set backspace=indent,eol,start " 退格键可跨行删除
set scrolloff=5             " 光标距边缘保留5行
set clipboard=unnamedplus "使用系统粘贴板为默认粘贴板



nnoremap ; :
nnoremap <space>b :buffers<cr>:b<space>
nnoremap <space>n :bn<cr>
nnoremap <space>p :bp<cr>
]]

-- Bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"



function init_lsp()
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

end


function init_cmp()

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
            --{ name = 'vsnip' },
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
        }),
    })

end



-- Setup lazy.nvim
require("lazy").setup({
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup()
            vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>")
            vim.keymap.set("n", "<M-f>", "<cmd>Telescope live_grep<CR>")
        end
    },

    {
        'neovim/nvim-lspconfig',
        config = function()
            init_lsp()
        end
    },

    {
        'hrsh7th/nvim-cmp',
        dependencies = { 'hrsh7th/cmp-nvim-lsp' , "hrsh7th/cmp-buffer", 'hrsh7th/cmp-path' },
        config = function()
            init_cmp()
        end

    },

    {
        "ibhagwan/fzf-lua",
        opts = {}
    },

    {
        'linzhi555/nvim-tree.lua',
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            vim.opt.termguicolors = true
            require("nvim-tree").setup(
                {
                    sort_by = "case_sensitive",
                    view = {
                        width = 60,
                    },
                    renderer = {
                        group_empty = true,
                    },
                    filters = {
                        dotfiles = true,
                    },
                })
            vim.api.nvim_set_keymap('n', '<space>t', ":NvimTreeToggle<CR>", { noremap = true, silent = true })
        end
    }


})


