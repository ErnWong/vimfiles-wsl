hi clear
if (exists("syntax_on"))
  syntax reset
endif

runtime bundle/base16-vim/colors/base16-paraiso.vim

let g:colors_name = "my-base16-paraiso"

highlight lineNr ctermbg=0
" highlight clear CursorLine
" highlight CursorLine ctermbg=1
" highlight CursorLineNr ctermbg=1
highlight ColorColumn ctermbg=0
" highlight clear VertSplit
" highlight VertSplit ctermbg=15 ctermfg=0
