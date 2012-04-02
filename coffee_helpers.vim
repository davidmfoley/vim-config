function! CoffeeLintFile()
  let current = fnamemodify(expand("%"), ':p')
  call CoffeeLintAnalyze(current)
endfunction

function! CoffeeLintAll()
  call CoffeeLintAnalyze('**/*.coffee')
endfunction

function! CoffeeLintAnalyze( path )
  exec ":silent :!coffeelint " . a:path . " 2>&1 | awk -F'\\#|( : )' '{printf( \"\\%s:\\%s:\\%s\\n\", $1, $2,$NF)}'  > ~/.coffeelint-results"
  exec ':cfile ~/.coffeelint-results'
endfunction
