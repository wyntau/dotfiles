## Sublime Text 2 Packages
First of all, you should have installed `Package Control`, if you haven't, press `ctrl` + `` ` ``, then input

    import urllib2,os; pf='Package Control.sublime-package'; ipp = sublime.installed_packages_path(); os.makedirs( ipp ) if not os.path.exists(ipp) else None; urllib2.install_opener( urllib2.build_opener( urllib2.ProxyHandler( ))); open( os.path.join( ipp, pf), 'wb' ).write( urllib2.urlopen( 'http://sublime.wbond.net/' +pf.replace( ' ','%20' )).read()); print( 'Please restart Sublime Text to finish installation')
then press `Enter`, the `Package Control` will be installed.

The Sublime Packages I used are listed below:

- AdvancedNewFile
- Alignment
- AlignTab
- <del>Autoprefixer</del>
- BracketHighlighter
- <del>Can I Use</del>
- CoffeeScript
- Color Highlighter
- <del>ColorPicker</del>
- CSScomb
- <del>DashDoc</del>
- DocBlockr
- Emmet
- Emmet Css Snippets
- GBK Encoding Support
- <del>Gist</del>
- <del>Git</del>
- GitGutter
- HTML-CSS-JS Prettify
- JsFormat
- JSHint
- <del>JSHint Gutter</del>
- LESS
- LineEndings
- Markdown Preview
- Package Control (required by all others)
- <del>Pretty JSON</del>
- PyV8 (auto installed by emmet)
- SidebarEnhancements
- <del>SublimeAStyleFormatter</del>
- <del>SublimeCodeIntel</del>
- SublimeLinter
- <del>SublimeREPL</del>
- Tag
- <del>Terminal</del>
- TrailingSpaces
- <del>Trimmer</del>
- VintageEX
