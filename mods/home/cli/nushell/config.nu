$env.config = {
  completions: {
    algorithm: "fuzzy"
    external: {
      enable: true
      completer: null
      max_results: 50
    }
    case_sensitive: false
    partial: true
    quick: true
    sort: "smart"
    use_ls_colors: true
  }

  datetime_format: {
    normal: '%a, %d %b %Y %H:%M:%S %z'    # shows up in displays of variables or other datetime's outside of tables
    table: '%m/%d/%y %I:%M:%S%p'          # generally shows up in tabular outputs such as ls. commenting this out will change it to the default human readable datetime format
  }

  edit_mode: "vi"

  error_style: "fancy" # "fancy" or "plain" for screen reader-friendly error messages

  history: {
    file_format: "sqlite"
    isolation: true
    max_size: 5_000_000
  }

  ls: {
    use_ls_colors: true # use the LS_COLORS environment variable to colorize output
    clickable_links: true # enable or disable clickable links. Your terminal has to support links.
  }

  # keybinds: [
  # ]

  recursion_limit: 50

  rm: {
    always_trash: true
  }

  show_banner: false
}
