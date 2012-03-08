
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

function! RunSpecsInCurrentFile(arg)
  let current = fnamemodify(expand("%"), ':p')

  if current =~ '/spec/'
    exec ':!rspec % -O ~/vim-spec.opts ' . a:arg
  else
    exec ':!rspec ' . AlternateFileName() . ' -O ~/vim-spec.opts ' . a:arg
  endif
endfunction

