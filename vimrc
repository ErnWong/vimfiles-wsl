set nocompatible
set encoding=utf-8
scriptencoding utf-8


"
" Plugins
"


call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'

" Intelligence:
Plug 'scrooloose/syntastic'
Plug 'editorconfig/editorconfig-vim'
Plug 'neoclide/coc.nvim'

" Languages:
Plug 'tpope/vim-liquid'
Plug 'PProvost/vim-ps1'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'iamcco/markdown-preview.nvim'
Plug 'othree/yajs.vim'
Plug 'gcorne/vim-sass-lint'
Plug 'rust-lang/rust.vim'

" Handy:
Plug 'tpope/vim-surround'

" UI:
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'christoomey/vim-tmux-navigator'
Plug 'qpkorr/vim-bufkill'
Plug 'francoiscabrol/ranger.vim'

" Git:
Plug 'tpope/vim-fugitive'

" Colorschemes:
Plug 'morhetz/gruvbox'

call plug#end()


"
" Mappings
"


let mapleader = '\\'
inoremap jk <esc>
nnoremap <space> :
vnoremap <space> :

" Close current buffer
nnoremap <C-c> :BD<cr>

" Window navigation
" - inspired from nicknisi
" - <C-hjkl> moves only, via tmux navigator
" - <C-w> hjkl creates new split
nnoremap <C-w>h :wincmd v<cr>
nnoremap <C-w>j :wincmd s<cr>:wincmd k<cr>
nnoremap <C-w>k :wincmd s<cr>
nnoremap <C-w>l :wincmd v<cr>:wincmd l<cr>

" Using Windows clipboard inside WSL Ubuntu
" This emulates an additional '"' register
" I know... it's magical...
" Note: requires paste.exe on the PATH
let is_this_not_on_wsl = system("uname -r | grep -q 'Microsoft' && echo $?")
if is_this_not_on_wsl == 0
  nnoremap <silent> ""y :set opfunc=WindowsYank<CR>g@
  vnoremap <silent> ""y :<C-U>call WindowsYank(visualmode(), 1)<CR>
  nnoremap <silent> ""p :call WindowsPaste('p')<CR>
  nnoremap <silent> ""P :call WindowsPaste('P')<CR>
  nnoremap <silent> ""gp :call WindowsPaste('gp')<CR>
  nnoremap <silent> ""gP :call WindowsPaste('gP')<CR>
  nnoremap <silent> ""]p :call WindowsPaste(']p')<CR>
  nnoremap <silent> ""[p :call WindowsPaste('[p')<CR>
  nnoremap <silent> ""]P :call WindowsPaste(']P')<CR>
  nnoremap <silent> ""[P :call WindowsPaste('[P')<CR>
  vnoremap <silent> ""p :call WindowsPaste('p', 1)<CR>
  vnoremap <silent> ""P :call WindowsPaste('P', 1)<CR>
endif

function! WindowsPaste(command, ...)
  " (1) Save original value of the unnamed register to restore later on
  let reg_save = @@

  " (2) Load clipboard into register
  let @@ = system('pushd /mnt/c/ > /dev/null && paste.exe && popd > /dev/null')

  " (3) Run whatever command was being run
  if a:0
    exe "normal! gv" . a:command
    " Don't revert unnamed register if inside visual mode
  else
    exe "normal! " . a:command
    " Revert unnamed register
    let @@ = reg_save
  endif
endfunction

function! WindowsYank(type, ...)
  " (1) Save original values for the selection setting
  " and the unnamed register
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@

  " (2) Yank text to unnamed register
  if a:0  " Invoked from Visual mode, use gv command.
    silent exe "normal! gvy"
  elseif a:type == 'line'
    silent exe "normal! '[V']y"
  else
    silent exe "normal! `[v`]y"
  endif

  " (3) Send contents of @@ to Windows clip.exe
  " Note: I've included a pushd-to-windows-directory to suppress warning
  " because windows warns about failing to translate working directory
  " when current working directory is inside wsl.
  echo system('pushd /mnt/c/ > /dev/null && clip.exe && popd > /dev/null', getreg('', 1, 1))

  " (4) Restore original settings and value of unnamed register
  let &selection = sel_save
  let @@ = reg_save
endfunction


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


set colorcolumn=100
set hlsearch
set number
set relativenumber
set numberwidth=4
set cursorline
set scrolloff=10
set listchars=tab:→\ ,trail:⋅
set list
set lazyredraw

" Alt: ─
set fillchars=fold:-,vert:│

" Always show status line
set laststatus=2

" Hide the '-- INSERT --' or the '-- [something mode] --'
" and use the airline status instead
set noshowmode

" Colorscheme
let g:gruvbox_italic = 1
let g:gruvbox_bold = 1
colorscheme gruvbox
set background=dark
set termguicolors
set t_8f=[38;2;%lu;%lu;%lum " Needed in tmux
set t_8b=[48;2;%lu;%lu;%lum " Needed in tmux
set t_ZH=[3m " Italics
set t_ZR=[23m " End italics
syntax on

" Colors gets messed up in large files otherwise...
autocmd BufEnter * syntax sync fromstart

" Airline
let g:airline_theme='gruvbox'
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
  let l:configFile = findfile('.sass-lint.yml', '.;')
  if l:configFile != ''
    let b:syntastic_scss_scss_lint_args = '--config ' . l:configFile
  endif
endf
autocmd FileType scss :call SetScssConfig()

let g:ale_completion_enabled = 1
let g:deoplete#enable_at_startup = 1

"
" Editor Settings
"


set tabstop=2
set shiftwidth=2
set expandtab
set breakindent
set noautochdir

" Keep hidden buffers
set hidden
