set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'
Bundle 'kien/ctrlp.vim'
Bundle 'mileszs/ack.vim'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
Bundle 'davidmfoley/tslime.vim'

Bundle 'kchmck/vim-coffee-script'

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

set wildignore+=*.class,.git,*.jar,tmp,.DS_Store,.jhw-cache,node_modules
let g:CommandTMaxHeight=20

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_warnings=1

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1

" resize the window with the arrow keys
map <Up> <c-w>-
map <Down> <c-w>+
map <Left> <c-w><
map <Right> <c-w>>

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
au BufRead,BufNewFile *.hamlbars set filetype=haml

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
source ~/.vim/coffee_helpers.vim

" flip between test/subject (same window, vsp, sp)
nnoremap <leader>tt :call FindOrCreateAlternate()<CR>
nnoremap <leader>tv :call TestToggleNewTabVertical()<CR>
nnoremap <leader>th :call TestToggleNewTabHorizontal()<CR>

nnoremap <leader>tr :call RunSpecsInCurrentFile('')<CR>
nnoremap <leader>tp :call RunSpecsInCurrentFile('--profile')<CR>

" toggle line numbers, wrapping, etc.
map <leader>tn :set invnumber<CR>
map <leader>tw :set nowrap!<CR>

" let g:ctrlp_custom_ignore = '\.*\|'
let g:ctrlp_working_path_mode = 0

function! Fuzzball(path)
  " call CommandTFlush
  " exec ":CommandT " . a:path
  exec ":CtrlP " . a:path
endfunction

map <leader>gX :ClearCtrlPCache<cr>
map <leader>gb :CtrlPBuffer<cr>
map <leader>gu :CtrlPMRU<cr>
" Command-T 'go to' (inspired by GRB)
map <leader>gJ :call Fuzzball('spec/javascripts')<cr>
map <leader>gr :call Fuzzball('')<cr>

function! RubyMode()
  map <leader>gv :call Fuzzball('app/views')<cr>
  map <leader>gc :call Fuzzball('app/controllers')<cr>
  map <leader>gm :call Fuzzball('app/models')<cr>
  map <leader>gl :call Fuzzball('lib')<cr>
  map <leader>gJ :call Fuzzball('spec/javascripts')<cr>
  map <leader>gg :call Fuzzball('$GEM_HOME/gems')<cr>
  map <leader>gf :call Fuzzball('features')<cr>
  if isdirectory('app/assets/')
    map <leader>gj :call Fuzzball('app/assets/javascripts')<cr>
    map <leader>gs :call Fuzzball('app/assets/stylesheets')<cr>
  else
    map <leader>gj :call Fuzzball('public/javascripts')<cr>
    map <leader>gs :call Fuzzball('public/stylesheets')<cr>
  end
  if isdirectory('spec/')
    map <leader>gL :call Fuzzball('spec/lib')<cr>
    map <leader>gV :call Fuzzball('spec/views')<cr>
    map <leader>gC :call Fuzzball('spec/controllers')<cr>
    map <leader>gM :call Fuzzball('spec/models')<cr>
    map <leader>gt :call Fuzzball('spec')<cr>
  else
    map <leader>gL :call Fuzzball('test/lib')<cr>
    map <leader>gV :call Fuzzball('test/views')<cr>
    map <leader>gC :call Fuzzball('test/controllers')<cr>
    map <leader>gM :call Fuzzball('test/models')<cr>
    map <leader>gt :call Fuzzball('test')<cr>
  end
endfunction

function! NodeMode()
  map <leader>gn :call Fuzzball('node_modules/')<cr>
endfunction

function! ClojureMode()
  map <leader>gs :call Fuzzball('src')<cr>
  map <leader>gt :call Fuzzball('test')<cr>
  map <leader>gl :call Fuzzball('lib')<cr>
endfunction

exec RubyMode()

map <leader>fa :call setreg('*', line('.'))<cr>:call setreg('c', col('.'))<cr>ggVG=<cr>:exec ":retab"<cr>:exec ":%s/ \\+$//"<cr>:exec ":" . getreg('*')<cr>
map <leader>fw :call setreg('*', line('.'))<cr>:call setreg('c',col('.'))<cr>:exec ":retab"<cr>:exec ":%s/ \\+$//"<cr>:exec ":" . getreg('*')<cr>

map <leader>fr :call ReekFile() %<cr>
map <leader>fl :!flog %<cr>

" Quickfix flog shortcuts
map <leader>fx :call FlogFile()<cr>
map <leader>fX :call FlogAll()<cr>

" Quickfix CoffeeLint shortcuts
map <leader>cx :call CoffeeLintFile()<cr>
map <leader>cX :call CoffeeLintAll()<cr>

" navigate through error list
"
map <leader>cc :cc<CR>
map <leader>cn :cn<CR>
map <leader>cp :cp<CR>

map <C-J> :cn<CR>
map <C-K> :cp<CR>

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

" send to tmux
vmap <leader>ee "ry :call Send_to_Tmux(@r)<CR>
nmap <leader>ee vip<,e>

" change tmux pane settings
nmap <leader>es :call Tmux_Vars()<CR>
