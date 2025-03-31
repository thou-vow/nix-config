$env.config = {
  edit_mode: "vi"

  completions: {
    algorithm: "fuzzy"
    external: {
      enable: true
      completer: {|spans|
        carapace $spans.0 nushell ...$spans | from json
      }
    }
    case_sensitive: false
    partial: true
    quick: true
    sort: "smart"
    use_ls_colors: true
  }

  history: {
    file_format: "sqlite"
    isolation: false
    max_size: 5_000_000
  }

  keybinds: [
  ]


  recursion_limit: 50

  rm: {
    always_trash: true
  }

  show_banner: true
}

