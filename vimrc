set nocompatible

set ruler
syntax on
set encoding=utf-8

set bs=2
set guioptions-=T
set guioptions-=L
set guioptions-=r

set showmatch
set nu
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

set tabstop=2
set expandtab
set shiftwidth=2
set exrc
set secure

let $JS_CMD='node'

" Command-T configuration
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

if has("gui_running")
  set guifont=Inconsolata-g:h12
  colorscheme desert256
  highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
else
  colorscheme desert
endif
highlight ExtraWhitespace guisp=Red ctermbg=Blue guibg=Blue

"if version >= 700
"  au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=undercurl guisp=Magenta
"  au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse
"endif

set vb
au BufRead,BufNewFile *.html.mustache set filetype=html

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
map <leader>b :FuzzyFinderBuffer<CR>
map <leader>n :FuzzyFinderFile<CR>


function! FindOrCreateAlternate()
  let buflist = []
  let bufcount = bufnr("$")
  let currbufnr = 1
  let altname = AlternateFileName()
  while currbufnr <= bufcount
    if(buflisted(currbufnr))
      let currbufname = bufname(currbufnr)

      let curmatch = tolower(currbufname)

      if(altname == currbufname)
        call add(buflist, currbufnr)
      endif
    endif
    let currbufnr = currbufnr + 1
  endwhile

  if(len(buflist) > 1)
    exec ":b " . get(buflist,0)
  else
    :w
    exec ":e " . altname
  endif

endfunction

function! AlternateFileName()
  "todo: deal with projects that have /spec/app
  let current = fnamemodify(expand("%"), ':p')
  if current =~ '/spec/'
    if current =~ '/spec/javascripts/'
      let altname = substitute(current, "/spec/","/public/", 'g')
      let altname = substitute(altname, "\Spec\.js", ".js",'g')
    else
      let altname = substitute(current, "/spec/lib/","/lib/", 'g')
      let altname = substitute(altname, "/spec/","/app/", 'g')
      let altname = substitute(altname, "\.erb_spec\.rb", ".erb",'g')
      let altname = substitute(altname, "_spec\.rb", ".rb",'g')
    endif
  elseif current =~ '/test/'
    " todo: deal with this
  else
    if current =~ '/javascripts/'
      let altname = substitute(current, "/public/","/spec/", 'g')
      let altname = substitute(altname, ".js", "Spec.js", 'g')
    else
      let altname = substitute(current, "/app/","/spec/", 'g')
      let altname = substitute(altname, "/lib/", "/spec/lib/", "g")

      let altname = substitute(altname, "\.rb", "_spec.rb", 'g')
    endif
  endif

  return altname
endfunction

function! TestToggleNewTabVertical()
  :vsplit
  call FindOrCreateAlternate()
endfunction

function! TestToggleNewTabHorizontal()
  :split
  call FindOrCreateAlternate()
endfunction

function! RunSpecsInCurrentFile(arg)
  let current = fnamemodify(expand("%"), ':p')

  if current =~ '/spec/'
    exec ':!rspec % -O ~/vim-spec.opts ' . a:arg
  else
    exec ':!rspec ' . AlternateFileName() . ' -O ~/vim-spec.opts ' . a:arg
  endif
endfunction

function! FormatDocument()
  call setreg('*', line('.'))
  exec 'ggVG='
endfunction

function! FlogFile()
  let current = fnamemodify(expand("%"), ':p')
  call FlogAnalyze(current)
endfunction

function! FlogAll()
  call FlogAnalyze('app lib -g')
endfunction

function! FlogAnalyze( path )
  exec ":silent :!flog " . a:path . " | " . " awk '" . "length($1) > 4 && match($3, /[0-9\.]+/) {printf( \"\\%s:\\%s - flog score - \\%s \\n\", $3, $2,$1)}'  > ~/.flog-results"
  exec ':cfile ~/.flog-results'
endfunction

set errorformat+=%f:%l:%m

function! ReekFile()
  let current = fnamemodify(expand("%"), ':p')
  exec ":!reek " . current . " | " . " awk '" . "length($1) > 4 &&length($3) > 0{printf( \"\\%s:\\%s - flog score - \\%s \\n\", $3, $2,$1)}'"
  "  exec ':cfile ~/.reek-results'
  "  exec ':lli'
endfunction

" flip between test/subject (same window, vsp, sp)
nnoremap <leader>tt :call FindOrCreateAlternate()<CR>
nnoremap <leader>tv :call TestToggleNewTabVertical()<CR>
nnoremap <leader>th :call TestToggleNewTabHorizontal()<CR>
nnoremap <leader>tr :call RunSpecsInCurrentFile('')<CR>
nnoremap <leader>tp :call RunSpecsInCurrentFile('--profile')<CR>

" toggle line numbers, wrapping, etc.
map <leader>tn :set invnumber<CR>
map <leader>tw :set nowrap!<CR>

" Command-T 'go to' (inspired by GRB)
map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
map <leader>gV :CommandTFlush<cr>\|:CommandT spec/views<cr>
map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
map <leader>gC :CommandTFlush<cr>\|:CommandT spec/controllers<cr>
map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
map <leader>gM :CommandTFlush<cr>\|:CommandT spec/models<cr>
map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
map <leader>gL :CommandTFlush<cr>\|:CommandT spec/lib<cr>
map <leader>gs :CommandTFlush<cr>\|:CommandT public/stylesheets<cr>
map <leader>gt :CommandTFlush<cr>\|:CommandT spec<cr>
map <leader>gj :CommandTFlush<cr>\|:CommandT public/javascripts<cr>
map <leader>gJ :CommandTFlush<cr>\|:CommandT spec/javascripts<cr>
map <leader>gr :CommandTFlush<cr>\|:CommandT <cr>
map <leader>gg :CommandTFlush<cr>\|:CommandT $GEM_HOME/gems<cr>
map <leader>gf :CommandTFlush<cr>\|:CommandT features<cr>

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
" map <C-j> <C-w>j
" map <C-k> <C-w>k
" map <C-l> <C-w>l
" map <C-h> <C-w>h

set textwidth=0

function! SuperCleverTab()
  if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
    return "\<Tab>"
  else
    return "\<C-N>"
  endif
endfunction

inoremap <Tab> <C-R>=SuperCleverTab()<cr>
"vmap r "_dP"

