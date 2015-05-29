set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

Bundle 'gmarik/Vundle.vim'

Bundle 'pangloss/vim-javascript'
Bundle 'brk3/groovyindent'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'kien/ctrlp.vim'
Bundle 'tfnico/vim-gradle'
Bundle 'godlygeek/tabular'
Bundle 'plasticboy/vim-markdown'
Bundle 'kchmck/vim-coffee-script'
Bundle 'digitaltoad/vim-jade'
Bundle 'wavded/vim-stylus'
Bundle 'Chiel92/vim-autoformat'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'Shutnik/jshint2.vim'
Bundle 'bling/vim-airline'
Bundle 'editorconfig/editorconfig-vim'
Bundle 'tpope/vim-abolish'
Bundle 'jplaut/vim-arduino-ino'
Bundle 'groenewege/vim-less'
Bundle 'mxw/vim-jsx'
Bundle 'bronson/vim-trailing-whitespace'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fugitive'
Bundle 'JazzCore/ctrlp-cmatcher'

syntax enable
set background=dark

filetype plugin indent on

set tabstop=2
set nu
set shiftwidth=2
set expandtab

set splitbelow
set splitright

map <Leader> <Plug>(easymotion-prefix)
autocmd BufWritePre *.py :%s/\s\+$//e

noremap <F6> :JSHint<CR>
let g:vim_markdown_folding_disabled=1

" Formatting stuff
let g:formatprg_args_js = '-s 2'
let g:formatprg_args_json = '-s 2'
let g:formatprg_args_css = '-f - -N -s 2'
noremap <F3> :Autoformat<CR>

" Ignore
let g:ctrlp_custom_ignore = {
  \ 'dir': 'node_modules\|bower_components\|dist'
  \ }

" Airline
let g:airline_theme='murmur'
let g:airline_powerline_fonts=1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
set laststatus=2

" Auto close HTML
autocmd BufRead,BufNewFile *.html,*.erb,*.ejs iabbrev </ </<C-X><C-O>
au BufRead,BufNewFile *.ejs set filetype=html
au BufRead,BufNewFile *.es6 set filetype=js

" Spell check md
autocmd BufRead,BufNewFile *.md setlocal spell

map Y y$

augroup vagrant
  au!
  au BufRead,BufNewFile Vagrantfile set filetype=ruby
augroup END

" Whitespace removal
" autocmd BufWritePre * :%s/\s\+$//e

" Mac stuff
set backspace=eol,indent,start

inoremap <C-c> CtrlPBufTag

let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
