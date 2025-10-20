(require (prefix-in cfg. "helix/configuration.scm"))

(define (key-values . key-values) (apply hash (apply append key-values)))

(for-each
  (lambda (language-name)
    (define original (cfg.get-language-config language-name))
    (define original-language-servers
      (let
        ((list-or-false (hash-try-get original 'language-servers)))
        (if (not list-or-false) '() list-or-false)))
    (cfg.update-language-config! language-name
      (key-values
        (list 'name language-name)
        (list 'language-servers
          (append
            original-language-servers
            (list "discord-rpc-lsp"))))))
  (list "c" "css" "fish" "java" "javascript" "json" "kdl" "nix" "rust" "scheme" "typescript" "typst" "yaml"))

(cfg.set-lsp-config! "discord-rpc-lsp"
  (key-values
    (list 'command "discord-rpc-lsp")))

(cfg.set-lsp-config! "nixd"
  (key-values
    (list 'args
      (list "--inlay-hints=true"))
    (list 'config
      (key-values
        (list 'nixd
          (key-values
            (list 'formatting
              (key-values
                (list 'command "alexjandra")))
            (list 'nixpkgs
              (key-values
                (list 'expr "import (builtins.getFlake \"self\").inputs.nixpkgs {}")))
            (list 'nixos
              (key-values
                (list 'expr "(bulltins.getFlake \"self\").nixosConfigurations.\"u\".options")))
            (list 'home-manager
              (key-values
                (list 'expr "(bulltins.getFlake \"self\").homeConfigurations.\"thou@u\".options")))))))))
