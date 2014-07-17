set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

Bundle "gmarik/Vundle.vim"

Bundle "tpope/vim-fugitive"
Bundle "Lokaltog/vim-easymotion"
Bundle "kien/ctrlp.vim"
Bundle "tfnico/vim-gradle"
Bundle "plasticboy/vim-markdown"
Bundle "kchmck/vim-coffee-script"
Bundle "digitaltoad/vim-jade"
Bundle "wavded/vim-stylus"
Bundle "wookiehangover/jshint.vim"
Bundle "Chiel92/vim-autoformat"

filetype plugin indent on     " required

set tabstop=2
set nu
set shiftwidth=2
set expandtab
syntax on

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

map <Leader> <Plug>(easymotion-prefix)
autocmd BufWritePre *.py :%s/\s\+$//e

" Formatting stuff
let g:formatprg_args_js = "-s 2"
let g:formatprg_args_json = "-s 2"
noremap <F3> :Autoformat<CR><CR>
