set nocompatible
"filetype off

" set rtp+=~/.vim/bundle/vundle/
" call vundle#rc()

" let Vundle manage Vundle
" required! 
"Bundle 'gmarik/vundle'

set ruler
syntax on
set encoding=utf-8

set bs=2
set guioptions-=T
set guioptions-=L
set guioptions-=r

set showmatch
" set nu
set whichwrap=<,>,h,l,[,]

set wrapmargin=0

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

set langmenu=none
set nobackup
set nowritebackup
set noswapfile
set hlsearch
set hidden
set tabstop=2
set expandtab
set shiftwidth=2
set exrc
set secure

let $JS_CMD='node'

" Command-T configuration
set wildignore+=*.class,.git,*.jar,tmp
let g:CommandTMaxHeight=20

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_warnings=1

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

set nofoldenable
let mapleader = ","

" make uses real tabs
au FileType make set noexpandtab

autocmd ColorScheme * highlight ExtraWhitespace ctermbg=Blue guibg=Blue
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/

source ~/.vim/color_settings.vim


source ~/.vim/clojure_settings.vim

set vb
au BufRead,BufNewFile *.html.mustache set filetype=html

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

source ~/.vim/alternate.vim

function! FormatDocument()
  call setreg('*', line('.'))
  exec 'ggVG='
endfunction

source ~/.vim/ruby_helpers.vim

" flip between test/subject (same window, vsp, sp)
nnoremap <leader>tt :call FindOrCreateAlternate()<CR>
nnoremap <leader>tv :call TestToggleNewTabVertical()<CR>
nnoremap <leader>th :call TestToggleNewTabHorizontal()<CR>

nnoremap <leader>tr :call RunSpecsInCurrentFile('')<CR>
nnoremap <leader>tp :call RunSpecsInCurrentFile('--profile')<CR>

" toggle line numbers, wrapping, etc.
map <leader>tn :set invnumber<CR>
map <leader>tw :set nowrap!<CR>

function! Fuzzball(path)
  call CommandTFlush
  exec ":CommandT " . a:path
endfunction

" Command-T 'go to' (inspired by GRB)
map <leader>gJ :CommandTFlush<cr>\|:CommandT spec/javascripts<cr>
map <leader>gr :CommandTFlush<cr>\|:CommandT <cr>

function! RubyMode()
  map <leader>gv :call Fuzzball('app/views')<cr>
  map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
  map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
  map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
  map <leader>gJ :CommandTFlush<cr>\|:CommandT spec/javascripts<cr>
  map <leader>gg :CommandTFlush<cr>\|:CommandT $GEM_HOME/gems<cr>
  map <leader>gf :CommandTFlush<cr>\|:CommandT features<cr>
  if isdirectory('app/assets/')
    map <leader>gj :CommandTFlush<cr>\|:CommandT app/assets/javascripts<cr>
    map <leader>gs :CommandTFlush<cr>\|:CommandT app/assets/stylesheets<cr>
  else
    map <leader>gj :CommandTFlush<cr>\|:CommandT public/javascripts<cr>
    map <leader>gs :CommandTFlush<cr>\|:CommandT public/stylesheets<cr>
  end
  if isdirectory('spec/')
    map <leader>gL :CommandTFlush<cr>\|:CommandT spec/lib<cr>
    map <leader>gV :CommandTFlush<cr>\|:CommandT spec/views<cr>
    map <leader>gC :CommandTFlush<cr>\|:CommandT spec/controllers<cr>
    map <leader>gM :CommandTFlush<cr>\|:CommandT spec/models<cr>
    map <leader>gt :CommandTFlush<cr>\|:CommandT spec<cr>
  else
    map <leader>gL :CommandTFlush<cr>\|:CommandT test/lib<cr>
    map <leader>gV :CommandTFlush<cr>\|:CommandT test/views<cr>
    map <leader>gC :CommandTFlush<cr>\|:CommandT test/controllers<cr>
    map <leader>gM :CommandTFlush<cr>\|:CommandT test/models<cr>
    map <leader>gt :CommandTFlush<cr>\|:CommandT test<cr>
  end
endfunction

function! ClojureMode()
  map <leader>gs :CommandTFlush<cr>\|:CommandT src<cr>
  map <leader>gt :CommandTFlush<cr>\|:CommandT test<cr>
  map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
endfunction

exec RubyMode()

map <leader>fa :call setreg('*', line('.'))<cr>:call setreg('c', col('.'))<cr>ggVG=<cr>:exec ":" . getreg('*')<cr>:exec ":%s/ \\+$//"<cr>
map <leader>fw :call setreg('*', line('.'))<cr>:call setreg('c',col('.'))<cr>:exec ":%s/ \\+$//"<cr>:exec ":" . getreg('*')<cr>

map <leader>fr :call ReekFile() %<cr>
map <leader>fl :!flog %<cr>

" Quickfix flog shortcuts
map <leader>fx :call FlogFile()<cr>
map <leader>fX :call FlogAll()<cr>

" navigate through error list
map <leader>cc :cc<CR>
map <leader>cn :cn<CR>
map <leader>cp :cp<CR>

set textwidth=0

function! SuperCleverTab()
  if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
    return "\<Tab>"
  else
    return "\<C-N>"
  endif
endfunction

inoremap <Tab> <C-R>=SuperCleverTab()<cr>
" ,k = ack for word under cursor
nmap <leader>k :let @/="\\<<C-R><C-W>\\>"<CR>:set hls<CR>:silent Ack "<C-R><C-W>"<CR>:ccl<CR>:cw<CR><CR>
vmap <leader>k y:let @/=escape(@", '\\[]$^*.')<CR>:set hls<CR>:silent Ack "<C-R>=escape(@", '\\"#')<CR>"<CR>:ccl<CR>:cw<CR><CR>

