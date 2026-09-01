; Work around a Neovim 0.12 / parser-query mismatch that can surface as:
; "attempt to call method 'range' (a nil value)" while parsing markdown.
;
; The upstream fenced-code injection reads the captured `(language)` node with
; `#set-lang-from-info-string!`. In this setup that capture can be nil, which
; breaks Treesitter highlighting for the whole session. We skip code fence
; injections entirely here and keep the safe markdown/html/frontmatter ones.

((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))

((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

([
  (inline)
  (pipe_table_cell)
] @injection.content
  (#set! injection.language "markdown_inline"))
