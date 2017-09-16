set nocompatible


"
" Vundle & Plugins
"


filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" Intelligence:
Plugin 'scrooloose/syntastic'
Plugin 'editorconfig/editorconfig-vim'

" Languages:
Plugin 'tpope/vim-liquid'
Plugin 'PProvost/vim-ps1'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'othree/yajs.vim'
Plugin 'gcorne/vim-sass-lint'

" Handy:
Plugin 'tpope/vim-surround'

" UI:
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'qpkorr/vim-bufkill'
Plugin 'francoiscabrol/ranger.vim'

" Git:
Plugin 'tpope/vim-fugitive'

" Colorschemes:
Plugin 'morhetz/gruvbox'
Plugin 'chriskempson/base16-vim'
Plugin 'NLKNguyen/papercolor-theme'

call vundle#end()

filetype plugin indent on


"
" Mappings
"


let mapleader = '\\'
imap jk <esc>
map <space> :

" Close current buffer
nmap <C-c> :BD<cr>

" Window navigation
" - inspired from nicknisi
" - <C-hjkl> moves only, via tmux navigator
" - <C-w> hjkl creates new split
nmap <C-w>h :wincmd v<cr>
nmap <C-w>j :wincmd s<cr>:wincmd k<cr>
nmap <C-w>k :wincmd s<cr>
nmap <C-w>l :wincmd v<cr>:wincmd l<cr>


"
" Backup & Persistance
"


" Backup
" - custom full path filenames
" - http://stackoverflow.com/a/38479550
" - writebackup = um... I forgot...
" - SaveBackups() by Victor Schroder
set nobackup
set writebackup
set backupdir=~/.vim/backup//

autocmd BufWritePre * :call SaveBackups()

function! SaveBackups()
  if expand('%:p') =~ &backupskip | return | endif
  if !filereadable(expand('%')) | return | endif
  for l:backupdir in split(&backupdir, ',')
    :call SaveBackup(l:backupdir)
    break
  endfor
endfunction

function! SaveBackup(backupdir)
  let l:filename = expand('%:p')
  if a:backupdir =~ '//$'
    let l:backup = escape(substitute(l:filename, '/', '%', 'g').&backupext, '%')
  else
    let l:backup = escape(expand('%').&backupext, '%')
  endif
  let l:backup_path = a:backupdir.l:backup
  :silent! execute '!cp "'.resolve(l:filename).'" "'.l:backup_path.'"'
endfunction

" Undo
" - double slash for complete path filenames
set undofile
set history=100
set undolevels=100
set undodir=~/.vim/undo//

" Swap
" - double slash for complete path filenames
set swapfile
set directory=~/.vim/swap//


"
" User Interface
"


set colorcolumn=80
set number
set relativenumber
set numberwidth=4
set cursorline
set scrolloff=10
set lazyredraw

" Alt: ─
set fillchars=fold:-,vert:│

" Always show status line
set laststatus=2

" Hide the '-- INSERT --' or the '-- [something mode] --'
" and use the airline status instead
set noshowmode

" Colorscheme
colorscheme gruvbox
set background=dark
set termguicolors
set t_8f=[38;2;%lu;%lu;%lum " Needed in tmux
set t_8b=[48;2;%lu;%lu;%lum " Needed in tmux
syntax on

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '│'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.crypt = '⌂'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.spell = '$'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'


"
" Intelligence
"


let g:syntastic_sass_checkers=["sasslint"]
let g:syntastic_scss_checkers=["sasslint"]
" Inspired by sblask (github.com/sblask/dotfiles)
fun! SetScssConfig()
  let configFile = findfile('.scss-lint.yml', '.')
  if configFile != ''
    let b:syntastic_scss_scss_lint_args = '--config ' . configFile
  endif
endf
autocmd FileType scss :call SetScssConfig()


"
" Editor Settings
"


set encoding=utf-8
set backspace=indent,eol,start
set tabstop=2
set shiftwidth=2
set expandtab
set breakindent
set noautochdir

" Keep hidden buffers
set hidden
