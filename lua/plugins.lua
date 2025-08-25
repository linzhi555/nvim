--vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use {
        "williamboman/nvim-lsp-installer",
        config = function()
            require("nvim-lsp-installer").setup {}
        end
    }

    use {
        'neovim/nvim-lspconfig',
        config = function()
            require('lsp_setting')
        end
    }

    use {
        'hrsh7th/nvim-cmp',
        config = function()
            require('completion')
        end

    }
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-vsnip'
    use {
        'hrsh7th/vim-vsnip',
        config = function()
            vim.g.vsnip_snippet_dir = '~/.config/nvim/snippets'
        end
    }

    --	use {
    --        'vim-airline/vim-airline',
    --        config = function()
    --            vim.g["airline#extensions#tabline#enabled"]=1
    --            vim.g["airline#extensions#tabline#buffer_nr_show"]=1
    --        end
    --    }

    use 'vim-scripts/taglist.vim'


    use { 'junegunn/fzf', run = './install --bin', }

    use {
        'junegunn/fzf.vim',
        config = function()
            vim.api.nvim_set_keymap('n', '<space>p',
                ":Files<CR>",
                { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<space>s',
                ":Rg<CR>",
                { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<space>b',
                ":Buffers<CR>",
                { noremap = true, silent = true })
        end
    }
    use 'mattn/emmet-vim'

    use {
        'lervag/vimtex',
        config = function()
            vim.cmd [[
            filetype plugin indent on
            syntax enable
            let g:vimtex_view_method = 'zathura'
            let g:vimtex_compiler_method = 'latexmk'
            let maplocalleader = ","
            au BufNewFile,BufRead *.tex nnoremap <space>v :VimtexView<CR>
            au BufNewFile,BufRead *.tex nnoremap <F5> :VimtexCompile<CR>
            ]]
        end
    }
    use {
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

    use {
        'francoiscabrol/ranger.vim',
        config = function()
            vim.api.nvim_set_keymap('n', '<space>r', ":Ranger<CR>", { noremap = true, silent = true })
        end
    }
    use 'rbgrouleff/bclose.vim'
end)
