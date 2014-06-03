## Sublime Text 2 Packages
First of all, you should have installed `Package Control`, if you haven't, press `ctrl` + `` ` ``, then input

    import urllib2,os,hashlib; h = '7183a2d3e96f11eeadd761d777e62404' + 'e330c659d4bb41d3bdf022e94cab3cd0'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); os.makedirs( ipp ) if not os.path.exists(ipp) else None; urllib2.install_opener( urllib2.build_opener( urllib2.ProxyHandler()) ); by = urllib2.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); open( os.path.join( ipp, pf), 'wb' ).write(by) if dh == h else None; print('Error validating download (got %s instead of %s), please try manual install' % (dh, h) if dh != h else 'Please restart Sublime Text to finish installation')
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
- <del>CSScomb</del>
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
- <del>LineEndings</del>
- Markdown Preview
- Package Control (required by all others)
- <del>Pretty JSON</del>
- PyV8 (auto installed by emmet)
- SCSS
- <del>SidebarEnhancements</del>
- <del>SublimeAStyleFormatter</del>
- <del>SublimeCodeIntel</del>
- SublimeLinter
- <del>SublimeREPL</del>
- <del>Tag</del>
- <del>Terminal</del>
- TrailingSpaces
- <del>Trimmer</del>
- View In Browser
- VintageEX
