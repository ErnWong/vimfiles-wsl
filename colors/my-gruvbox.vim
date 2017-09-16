hi clear
if (exists("syntax_on"))
  syntax reset
endif

runtime bundle/gruvbox/colors/gruvbox.vim

let g:colors_name = "my-gruvbox"

highlight lineNr ctermbg=0
highlight clear CursorLine
highlight CursorLine ctermbg=0
highlight CursorLineNr ctermbg=0
highlight ColorColumn ctermbg=0
" highlight clear VertSplit
" highlight VertSplit ctermbg=15 ctermfg=0
highlight Normal ctermbg=0
