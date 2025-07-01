{
  config,
  lib,
  ...
}: let
  normalMode = {
    "'" = "repeat_last_motion";
    "\"" = "select_register";
    "%" = "select_all";
    "(" = "rotate_selections_backward";
    ")" = "rotate_selections_forward";
    "minus" = "decrement";
    "_" = "trim_selections";
    "+" = "increment";
    "y" = "yank";
    "h" = "move_char_left";
    "j" = "move_visual_line_down";
    "S-j" = [
      "move_visual_line_down"
      "scroll_down"
    ];
    "k" = "move_visual_line_up";
    "S-k" = [
      "move_visual_line_up"
      "scroll_up"
    ];
    "l" = "move_char_right";
    "\\" = "flip_selections";
    "x" = "extend_line_below";
    "S-x" = "extend_line_above";
    "v" = "select_mode";
    "," = "keep_primary_selection";
    "<" = "unindent";
    ">" = "indent";
    ";" = "collapse_selection";
    ":" = "command_mode";
    "ret" = [
      "move_line_down"
      "goto_first_nonwhitespace"
    ];
    "down" = "scroll_down";
    "up" = "scroll_up";
  };
  caseMinorMode = {
    "minus" = "switch_to_lowercase";
    "+" = "switch_to_uppercase";
    "\\" = "switch_case";
  };
  languageMinorMode = {
    "r" = "rename_symbol";
    "x" = "completion";
    "c" = "toggle_line_comments";
    "S-c" = "toggle_block_comments";
    "/" = [
      "align_view_top"
      "hover"
    ];
    "?" = "signature_help";
    "ret" = "code_action";
  };
  configMinorMode = {
    "i" = ":toggle-option lsp.display-inlay-hints";
    "s" = ":toggle-option auto-pairs";
    "d" = ":toggle-option inline-diagnostics.cursor-line disable hint";
    "x" = ":toggle-option soft-wrap.enable";
    "/" = ":toggle-option search.smart-case";
    "ret" = ":open ${config.mods.flakePath}";
  };
  bufferMinorMode = {
    "'" = "goto_last_accessed_file";
    "q" = ":buffer-close";
    "S-q" = ":buffer-close!";
    "w" = ":write";
    "S-w" = ":write!";
    "r" = ":reload";
    "o" = ":buffer-close-others";
    "S-o" = ":buffer-close-others!";
    "s" = "goto_file";
    "f" = ":format";
    "h" = "goto_previous_buffer";
    "l" = "goto_next_buffer";
    "z" = "suspend";
    "n" = ":new";
    "." = "goto_last_modified_file";
    "space" = "buffer_picker";
  };
  longWordMinorMode = {
    "h" = "move_prev_long_word_start";
    "S-h" = "move_prev_long_word_end";
    "l" = "move_next_long_word_end";
    "S-l" = "move_next_long_word_start";
  };
  wordMinorMode = {
    "h" = "move_prev_word_start";
    "S-h" = "move_prev_word_end";
    "l" = "move_next_word_end";
    "S-l" = "move_next_word_start";
  };
  subWordMinorMode = {
    "h" = "move_prev_sub_word_start";
    "S-h" = "move_prev_sub_word_end";
    "l" = "move_next_sub_word_end";
    "S-l" = "move_next_sub_word_start";
  };
  replaceMinorMode = {
    "q" = "@sj<S-w>rr";
    "w" = "@sjwrr";
    "r" = "change_selection_noyank";
    "y" = "change_selection";
    "p" = "replace_with_yanked";
    "s" = "surround_replace";
    "h" = [
      "collapse_selection"
      "extend_to_first_nonwhitespace"
      "change_selection_noyank"
    ];
    "l" = [
      "collapse_selection"
      "extend_to_line_end"
      "change_selection_noyank"
    ];
    "x" = [
      "collapse_selection"
      "extend_to_line_bounds"
      "change_selection_noyank"
    ];
    "c" = "replace";
  };
  treeMinorMode = {
    "h" = "select_prev_sibling";
    "S-h" = "move_parent_node_start";
    "j" = "shrink_selection";
    "k" = "expand_selection";
    "l" = "select_next_sibling";
    "S-l" = "move_parent_node_end";
  };
  undoMinorMode = {
    "h" = "undo";
    "S-h" = "earlier";
    "l" = "redo";
    "S-l" = "later";
  };
  insertMinorMode = {
    "s" = "surround_add";
    "h" = "insert_mode";
    "S-h" = "insert_at_line_start";
    "j" = "open_below";
    "S-j" = "add_newline_below";
    "k" = "open_above";
    "S-k" = "add_newline_above";
    "l" = "append_mode";
    "S-l" = "insert_at_line_end";
  };
  pasteMinorMode = {
    "h" = "paste_before";
    "S-h" = [
      "goto_first_nonwhitespace"
      "paste_before"
    ];
    "l" = "paste_after";
    "S-l" = [
      "goto_line_end"
      "paste_after"
    ];
  };
  jumpMinorMode = {
    "w" = "save_selection";
    "h" = "jump_backward";
    "l" = "jump_forward";
  };
  selectionMinorMode = {
    "q" = "@sj<S-w>";
    "w" = "@sjw";
    "f" = "format_selections";
    "h" = "extend_to_first_nonwhitespace";
    "S-h" = "extend_to_line_start";
    "j" = "select_textobject_inner";
    "S-j" = "join_selections";
    "k" = "select_textobject_around";
    "l" = "extend_to_line_end";
    "S-l" = "extend_to_line_end_newline";
    "x" = "extend_to_line_bounds";
    "S-x" = "shrink_to_line_bounds";
    "\\" = "ensure_selections_forward";
  };
  deleteMinorMode = {
    "q" = "@sj<S-w>dd";
    "w" = "@sjwdd";
    "y" = "delete_selection";
    "s" = "surround_delete";
    "d" = "delete_selection_noyank";
    "h" = [
      "collapse_selection"
      "extend_to_first_nonwhitespace"
      "delete_selection_noyank"
    ];
    "l" = [
      "collapse_selection"
      "extend_to_line_end"
      "delete_selection_noyank"
    ];
    "x" = [
      "collapse_selection"
      "extend_to_line_bounds"
      "delete_selection_noyank"
    ];
  };
  findMinorMode = {
    "h" = "till_prev_char";
    "S-h" = "find_prev_char";
    "l" = "find_till_char";
    "S-l" = "find_next_char";
  };
  gotoMinorMode = {
    "w" = "goto_word";
    "r" = "goto_reference";
    "t" = "goto_type_definition";
    "i" = "goto_implementation";
    "s" = "match_brackets";
    "d" = "goto_definition";
    "S-d" = "goto_declaration";
    "h" = "goto_first_nonwhitespace";
    "S-h" = "goto_line_start";
    "j" = "move_line_down";
    "S-j" = "goto_last_line";
    "k" = "move_line_up";
    "S-k" = "goto_file_start";
    "l" = "goto_line_end";
    "S-l" = "goto_line_end_newline";
    "x" = "goto_window_center";
    "." = "goto_last_modification";
    "ret" = "goto_line";
    "down" = "goto_window_bottom";
    "up" = "goto_window_top";
  };
  prevImpairMinorMode = {
    "tab" = "goto_prev_tabstop";
    "e" = "goto_prev_entry";
    "t" = "goto_prev_class";
    "S-t" = "goto_prev_test";
    "p" = "goto_prev_paragraph";
    "a" = "goto_prev_parameter";
    "d" = "goto_prev_diag";
    "S-d" = "goto_first_diag";
    "f" = "goto_prev_function";
    "g" = "goto_prev_change";
    "S-g" = "goto_first_change";
    "c" = "goto_prev_comment";
  };
  nextImpairMinorMode = {
    "tab" = "goto_next_tabstop";
    "e" = "goto_next_entry";
    "t" = "goto_next_class";
    "S-t" = "goto_next_test";
    "p" = "goto_next_paragraph";
    "a" = "goto_next_parameter";
    "d" = "goto_next_diag";
    "S-d" = "goto_last_diag";
    "f" = "goto_next_function";
    "g" = "goto_next_change";
    "S-g" = "goto_last_change";
    "c" = "goto_next_comment";
  };
  viewMinorMode = {
    "y" = "align_view_middle";
    "j" = "page_cursor_half_down";
    "S-j" = "page_cursor_down";
    "k" = "page_cursor_half_up";
    "S-k" = "page_cursor_up";
    "x" = "align_view_center";
    "up" = "align_view_bottom";
    "down" = "align_view_top";
  };
  cursorMinorMode = {
    "(" = "rotate_selection_contents_backward";
    ")" = "rotate_selection_contents_forward";
    "y" = "yank_joined";
    "s" = "select_references_to_symbol_under_cursor";
    "f" = "keep_selections";
    "S-f" = "remove_selections";
    "h" = "copy_selection_on_prev_line";
    "j" = "select_all_children";
    "S-j" = "join_selections_space";
    "k" = "select_all_siblings";
    "l" = "copy_selection_on_next_line";
    "\\" = "reverse_selection_contents";
    "|" = "align_selections";
    "x" = "split_selection_on_newline";
    "m" = "merge_selections";
    "S-m" = "merge_consecutive_selections";
    "," = "remove_primary_selection";
    "space" = "split_selection";
    "ret" = "select_regex";
  };
  windowMinorMode = {
    "q" = "wclose";
    "t" = "transpose_view";
    "y" = "vsplit";
    "o" = "wonly";
    "h" = "jump_view_left";
    "S-h" = "swap_view_left";
    "j" = "jump_view_down";
    "S-j" = "swap_view_down";
    "k" = "jump_view_up";
    "S-k" = "swap_view_up";
    "l" = "jump_view_right";
    "S-l" = "swap_view_right";
    "x" = "hsplit";
  };
  macroMinorMode = {
    "w" = "record_macro";
    "m" = "replay_macro";
  };
  searchMinorMode = {
    "w" = "make_search_word_bounded";
    "y" = "search_selection";
    "h" = "search_prev";
    "j" = "search";
    "k" = "rsearch";
    "l" = "search_next";
  };
  spaceMinorMode = {
    "'" = "last_picker";
    "tab" = "file_picker_in_current_buffer_directory";
    "S-tab" = "file_explorer_in_current_buffer_directory";
    "q" = ":quit";
    "S-q" = ":quit!";
    "w" = ":write-all";
    "S-w" = ":write-all!";
    "S-r" = ":reload-all";
    "n" = "jumplist_picker";
    "s" = "symbol_picker";
    "S-s" = "workspace_symbol_picker";
    "d" = "diagnostics_picker";
    "S-d" = "workspace_diagnostics_picker";
    "g" = "changed_file_picker";
    "," = "file_picker";
    "<" = "file_explorer";
    "." = "file_picker_in_current_directory";
    ">" = "file_explorer_in_current_directory";
    "/" = "global_search";
    "?" = "command_palette";
  };
  spaceMinorModeCommand = {
    "r" = "@:sh rm -r <C-r>%";
    "o" = "@:o <C-r>%";
    "s" = "@:sh ln -s <C-r>% <C-r>%";
    "d" = "@:sh mkdir <C-r>%";
    "g" = "@:cd <C-r>%";
    "c" = "@:sh cp -r <C-r>% <C-r>%";
    "m" = "@:mv <C-r>%";
    "S-m" = "@:sh mv <C-r>% <C-r>%";
  };
  convertMovementToSelect = string: let
    commandMap = {
      "move_char_left" = "extend_char_left";
      "move_visual_line_down" = "extend_visual_line_down";
      "move_visual_line_up" = "extend_visual_line_up";
      "move_char_right" = "extend_char_right";
      "move_line_down" = "extend_line_down";
      "move_line_up" = "extend_line_up";
      "move_prev_long_word_start" = "extend_prev_long_word_start";
      "move_next_long_word_start" = "extend_next_long_word_start";
      "move_prev_long_word_end" = "extend_prev_long_word_end";
      "move_next_long_word_end" = "extend_next_long_word_end";
      "move_prev_sub_word_start" = "extend_prev_sub_word_start";
      "move_next_sub_word_start" = "extend_next_sub_word_start";
      "move_prev_sub_word_end" = "extend_prev_sub_word_end";
      "move_next_sub_word_end" = "extend_next_sub_word_end";
      "move_prev_word_start" = "extend_prev_word_start";
      "move_next_word_start" = "extend_next_word_start";
      "move_prev_word_end" = "extend_prev_word_end";
      "move_next_word_end" = "extend_next_word_end";
      "move_parent_node_start" = "extend_parent_node_start";
      "move_parent_node_end" = "extend_parent_node_end";
      "goto_first_nonwhitespace" = "extend_to_first_nonwhitespace";
      "goto_file_start" = "extend_to_file_start";
      "goto_file_end" = "extend_to_file_end";
      "goto_line_end" = "extend_to_line_end";
      "goto_last_line" = "extend_to_last_line";
      "find_next_char" = "extend_next_char";
      "find_prev_char" = "extend_prev_char";
      "find_till_char" = "extend_till_char";
      "till_prev_char" = "extend_till_prev_char";
      "goto_word" = "extend_to_word";
      "goto_line_start" = "extend_to_line_start";
      "goto_line_end_newline" = "extend_to_line_end_newline";
      "search_next" = "extend_search_next";
      "search_prev" = "extend_search_prev";
    };
  in
    commandMap.${string} or string;
  convertBindingsToSelect = value:
    if builtins.isString value
    then convertMovementToSelect value
    else if builtins.isList value
    then map convertMovementToSelect value
    else if builtins.isAttrs value
    then lib.mapAttrs (_: convertBindingsToSelect) value
    else value;
  normal =
    normalMode
    // {
      "@" = caseMinorMode;
      "=" = languageMinorMode;
      "§" = configMinorMode;
      "tab" = bufferMinorMode;
      "q" = longWordMinorMode;
      "w" = wordMinorMode;
      "e" = subWordMinorMode;
      "r" = replaceMinorMode;
      "t" = treeMinorMode;
      "u" = undoMinorMode;
      "o" = insertMinorMode;
      "p" = pasteMinorMode;
      "a" = jumpMinorMode;
      "s" = selectionMinorMode;
      "d" = deleteMinorMode;
      "f" = findMinorMode;
      "g" = gotoMinorMode;
      "S-h" = prevImpairMinorMode;
      "S-l" = nextImpairMinorMode;
      "z" = viewMinorMode;
      "c" = cursorMinorMode;
      "b" = windowMinorMode;
      "m" = macroMinorMode;
      "/" = searchMinorMode;
      "space" =
        spaceMinorMode
        // {
          ":" = spaceMinorModeCommand;
        };
    };
  insert = {
    "esc" = "normal_mode";
    "tab" = "smart_tab";
    "S-tab" = "insert_tab";
    "C-r" = "insert_register";
    "C-u" = "commit_undo_checkpoint";
    "C-x" = "completion";
    "C-/" = [
      "signature_help"
      "hover"
    ];
    "ret" = "insert_newline";
    "backspace" = "delete_char_backward";
    "S-backspace" = "delete_char_backward";
    "del" = "delete_char_forward";
    "S-del" = "delete_char_forward";
    "left" = "move_char_left";
    "down" = "move_visual_line_down";
    "up" = "move_visual_line_up";
    "right" = "move_char_right";
  };
  select =
    convertBindingsToSelect normal
    // {
      "v" = "exit_select_mode";
    };
in {
  config = lib.mkIf config.mods.helix.enable {
    programs.helix.settings.keys = lib.recursiveUpdate (import ./cleared-default-bindings.nix) {
      inherit normal insert select;
    };
  };
}
