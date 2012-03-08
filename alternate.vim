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
  let current = fnamemodify(expand("%"), ':p')
  let current = fnamemodify(expand("%"), ':p')
  let has_asset_pipeline = isdirectory('app/assets/')

  let has_spec = isdirectory('spec/')
  if has_spec
    let spec_root = '/spec/'
    let spec_suffix = '_spec'
  else
    let spec_root = '/test/'
    let spec_suffix = '_test'
  end

  if current =~ '\.rb$'
    return AlternateFileNameRuby(current, spec_root, spec_suffix)
  elseif current =~ '\.clj$'
    return AlternateFileNameClojure(current)
  elseif current =~ '\.coffee$'
    return AlternateFileNameCoffee(current)
  elseif current =~ '\.js$'
    return AlternateFileNameJavascript(current, has_asset_pipeline, spec_root)
  endif
  return current
endfunction

function! AlternateFileNameCoffee(current)
  if a:current =~ '/spec/'
    let altname = substitute(a:current, '/spec/', '/src/', 'g')
    let altname = substitute(altname, '_spec.clj', '.clj', 'g')
  else
    let altname = substitute(a:current, '/src/', '/spec/', 'g')
    let altname = substitute(altname, '.clj', '_spec.clj', 'g')
  end
  return altname
endfunction

function! AlternateFileNameClojure(current)
  if a:current =~ '/test/'
    let altname = substitute(a:current, '/test/', '/src/', 'g')
    let altname = substitute(altname, '_test.clj', '.clj', 'g')
  else
    let altname = substitute(a:current, '/src/', '/test/', 'g')
    let altname = substitute(altname, '.clj', '_test.clj', 'g')
  end
  return altname
endfunction

function! AlternateFileNameJavascript(current, has_asset_pipeline, spec_root)
  let current = a:current
  let has_asset_pipeline = a:has_asset_pipeline
  let spec_root = a:spec_root
  if current =~ spec_root
    if has_asset_pipeline
      let altname = substitute(current, spec_root,"/app/assets/", 'g')
    else
      let altname = substitute(current, spec_root,"/public/", 'g')
    end

    let altname = substitute(altname, "\Spec\.js", ".js",'g')
  else
    if current =~ '/app/assets/javascripts'
      let altname = substitute(current, "/app/assets/",spec_root, 'g')
    elseif current =~ '/javascripts/'
      let altname = substitute(current, "/public/", spec_root, 'g')
    endif
    let altname = substitute(altname, ".js", "Spec.js", 'g')
  endif

  return altname
endfunction

function! AlternateFileNameRuby(current, spec_root, spec_suffix)
  let current = a:current
  let spec_root = a:spec_root
  let spec_suffix = a:spec_suffix

  if current =~ spec_root
      let altname = substitute(current, spec_root . "lib/","/lib/", 'g')
      let altname = substitute(altname, spec_root,"/app/", 'g')
      let altname = substitute(altname, spec_suffix . "\.rb", ".rb",'g')
  else
      let altname = substitute(current, "/app/", spec_root, 'g')
      let altname = substitute(altname, "/lib/", spec_root . "lib/", "g")

      let altname = substitute(altname, "\.rb", spec_suffix . ".rb", 'g')
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

