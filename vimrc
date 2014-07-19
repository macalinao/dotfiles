set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

Bundle "gmarik/Vundle.vim"

Bundle "tpope/vim-fugitive"
Bundle "Lokaltog/vim-easymotion"
Bundle "kien/ctrlp.vim"
Bundle "tfnico/vim-gradle"
Bundle "godlygeek/tabular"
Bundle "plasticboy/vim-markdown"
Bundle "kchmck/vim-coffee-script"
Bundle "digitaltoad/vim-jade"
Bundle "wavded/vim-stylus"
Bundle "Chiel92/vim-autoformat"
Bundle "christoomey/vim-tmux-navigator"
Bundle "Shutnik/jshint2.vim"

filetype plugin indent on

set tabstop=2
set nu
set shiftwidth=2
set expandtab
syntax on

set splitbelow
set splitright

map <Leader> <Plug>(easymotion-prefix)
autocmd BufWritePre *.py :%s/\s\+$//e

noremap <F6> :JSHint<CR>
let g:vim_markdown_folding_disabled=1

" Formatting stuff
let g:formatprg_args_js = "-s 2"
let g:formatprg_args_json = "-s 2"
noremap <F3> :Autoformat<CR>

" Ignore
let g:ctrlp_custom_ignore = {
  \ 'dir': 'node_modules\|bower_components'
  \ }
