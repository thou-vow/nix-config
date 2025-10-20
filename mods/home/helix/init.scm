(require (prefix-in cfg. "helix/configuration.scm"))
(require (prefix-in cmd. "helix/commands.scm"))
(require "keybindings.scm")

(define (key-values . key-values) (apply hash (apply append key-values)))

(cmd.theme "theme")

(cfg.set-option! 'bufferline "always")
(cfg.set-option! 'color-modes #t)
(cfg.set-option! 'popup-border "all")

(cfg.set-option! 'default-yank-register "+")

(cfg.set-option! 'cursorcolumn #t)
(cfg.set-option! 'cursorline #t)
(cfg.set-option! 'line-number "relative")
(cfg.set-option! 'text-width 120)
(cfg.set-option! 'scrolloff 3)

(cfg.set-option! 'idle-timeout 0)
(cfg.set-option! 'completion-trigger-len 1)
(cfg.set-option! 'completion-timeout 0)
(cfg.set-option! 'completion-replace #t)

(cfg.set-option! 'cursor-shape.normal "bar")
(cfg.set-option! 'cursor-shape.insert "bar")
(cfg.set-option! 'cursor-shape.select "bar")

(cfg.set-option! 'end-of-line-diagnostics "hint")
(cfg.set-option! 'file-picker.hidden #f)

(cfg.set-option! 'indent-guides.render #f)
(cfg.set-option! 'indent-guides.character "▏")
(cfg.set-option! 'indent-guides.skip-levels 1)

(cfg.set-option! 'inline-diagnostics.cursor-line "disable")
(cfg.set-option! 'inline-diagnostics.other-lines "disable")

(cfg.set-option! 'lsp.enable #t)
(cfg.set-option! 'lsp.auto-signature-help #f)
(cfg.set-option! 'lsp.display-messages #t)
(cfg.set-option! 'lsp.display-inlay-hints #t)

(cfg.set-option! 'search.smart-case #t)

(cfg.set-option! 'soft-wrap.enable #t)

(cfg.set-option! 'statusline.left
  '("mode"
    "separator"
    "workspace-diagnostics"
    "spinner"
    "separator"
    "selections"
    "separator"
    "register"))
(cfg.set-option! 'statusline.center
  '("file-name"
    "separator"
    "version-control"))
(cfg.set-option! 'statusline.right
  '("file-modification-indicator"
    "separator"
    "read-only-indicator"
    "separator"
    "diagnostics"
    "separator"
    "position"
    "separator"
    "position-percentage"))
(cfg.set-option! 'statusline.separator "")

(for-each
  (lambda (language-name)
    (cfg.update-language-config! language-name
      (key-values
        (list 'name language-name)
        (list 'auto-format #f)
        (list 'indent
          (key-values
            (list 'tab-width 2)
            (list 'unit "\t"))))))
  (list "c" "css" "fish" "java" "javascript" "json" "kdl" "nix" "rust" "scheme" "typescript" "typst" "yaml"))

(cfg.update-language-config! "nix"
  (key-values
    (list 'name "nix")
    (list 'formatter
      (key-values
        (list 'command "alejandra")))))
(cfg.update-language-config! "scheme"
  (key-values
    (list 'name "scheme")
    (list 'formatter
      (key-values
        (list 'command "schemat")))
    (list 'language-servers (list "steel-language-server"))))

(cfg.set-lsp-config! "rust-analyzer"
  (key-values
    (list 'config
      (key-values
        (list 'check
          (key-values
            (list 'command "clippy")))))))

(cfg.set-lsp-config! "steel-language-server"
  (key-values
    (list 'command "steel-language-server")))

(cfg.set-lsp-config! "tinymist"
  (key-values
    (list 'config
      (key-values
        (list 'exportPdf "onSave")))))
