" Settings for VimClojure
let vimclojure#HighlightBuiltins=1
let vimclojure#ParenRainbow=1
let vimclojure#WantNailgun=1
let vimclojure#NailgunClient = "/usr/local/bin/ng"
let g:vimclojure#ParenRainbowColorsDark = {
					\ '1': 'ctermfg=yellow      guifg=orange1',
					\ '2': 'ctermfg=green       guifg=yellow1',
					\ '3': 'ctermfg=magenta     guifg=greenyellow',
					\ '4': 'ctermfg=yellow      guifg=green1',
					\ '5': 'ctermfg=green         guifg=springgreen1',
					\ '6': 'ctermfg=magenta      guifg=cyan1',
					\ '7': 'ctermfg=yellow        guifg=slateblue1',
					\ '8': 'ctermfg=green        guifg=magenta1',
					\ '9': 'ctermfg=magenta     guifg=purple1'
					\ }
let classpath = join(
   \[".",
   \ "src", "src/main/clojure", "src/main/resources",
   \ "test", "src/test/clojure", "src/test/resources",
   \ "classes", "target/classes",
   \ "lib/*", "lib/dev/*",
   \ "bin",
   \ "~/.vim/lib/*", "~/.vim/bin/*"
   \],
   \ ":")
