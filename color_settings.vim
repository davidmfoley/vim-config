
colorscheme desert256
if has("gui_running")
  set guifont=Inconsolata-g:h12
  highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
endif
highlight ExtraWhitespace guisp=Red ctermbg=Blue guibg=Blue

if version >= 700
  au InsertEnter * hi StatusLine ctermbg=0 ctermfg=1  gui=undercurl guisp=Magenta
  au InsertLeave * hi StatusLine ctermfg=4 ctermbg=2 gui=bold,reverse
endif

