(require-builtin helix/core/keymaps as keymaps.)
(require (prefix-in cfg. "helix/configuration.scm"))

(define normal-mode (hash
  "%" "select_all"
  "&" "align_selections"
  '* "search_selection_detect_word_boundaries"
  'C-* "search_selection"
  "(" "rotate_selections_backward"
  ")" "rotate_selections_forward"
  'minus "decrement"
  '_ "trim_selections"
  '= "increment"
  '+ (hash
    'i ":toggle-option lsp.display-inlay-hints"
    's ":toggle-option auto-pairs"
    'd ":toggle-option inline-diagnostics.cursor-line disable hint"
    'x ":toggle-option soft-wrap.enable"
    '/ ":toggle-option search.smart-case")
  'tab (hash
    'q ":buffer-close"
    'Q ":buffer-close!"
    'w ":write"
    'W ":write!"
    'R ":reload"
    't ":new"
    'p "goto_previous_buffer"
    's "goto_file"
    'f ":format"
    'n "goto_next_buffer")
  'q "move_next_long_word_end"
  'Q "move_prev_long_word_start"
  'C-q "move_next_long_word_start"
  'C-Q "move_prev_long_word_end"
  'w "move_next_word_end"
  'W "move_prev_word_start"
  'C-w "move_next_word_start"
  'C-W "move_prev_word_end"
  'e "move_next_sub_word_end"
  'E "move_prev_sub_word_start"
  'C-e "move_next_sub_word_start"
  'C-E "move_prev_sub_word_end"
  'r "replace"
  'R "replace_with_yanked"
  'C-r (hash
    'minus "switch_to_lowercase"
    '= "switch_to_uppercase"
    'space "switch_case")
  't "find_till_char"
  'T "till_prev_char"
  'y "yank"
  'u "undo"
  'U "redo"
  'C-u "page_cursor_half_up"
  'C-U "page_cursor_up"
  'i "insert_mode"
  'I "insert_at_line_start"
  'o "open_below"
  'O "open_above"
  'p "paste_after"
  'P "paste_before"
  "[" (hash
    'e "goto_prev_entry"
    't "goto_prev_class"
    'T "goto_prev_test"
    'p "goto_prev_paragraph"
    'a "goto_prev_parameter"
    'd "goto_prev_diag"
    'D "goto_first_diag"
    'f "goto_prev_function"
    'g "goto_prev_change"
    'G "goto_first_change"
    'x "goto_prev_xml_element"
    'c "goto_prev_comment"
    'space "add_newline_above")
  "]" (hash
    'e "goto_next_entry"
    't "goto_next_class"
    'T "goto_next_test"
    'p "goto_next_paragraph"
    'a "goto_next_parameter"
    'd "goto_next_diag"
    'D "goto_last_diag"
    'f "goto_next_function"
    'g "goto_next_change"
    'G "goto_last_change"
    'x "goto_next_xml_element"
    'c "goto_next_comment"
    'space "add_newline_below")
  'a "append_mode"
  'A "insert_at_line_end"
  's (hash
    "(" "rotate_selection_contents_backward"
    ")" "rotate_selection_contents_forward"
    'y "yank_joined"
    'p "copy_selection_on_prev_line"
    's "select_regex"
    'j "join_selections"
    'J "join_selections_space"
    'k "keep_selections"
    'K "remove_selections"
    'x "split_selection_on_newline"
    'n "copy_selection_on_next_line"
    'm "merge_selections"
    'M "merge_consecutive_selections"
    "," "remove_primary_selection")
  'S "split_selection"
  'C-s (hash
    'i "shrink_selection"
    'I "select_all_children"
    'o "expand_selection"
    'O "select_all_siblings"
    'p "select_prev_sibling"
    'P "move_parent_node_start"
    'n "select_next_sibling"
    'N "move_parent_node_end")
  'd "delete_selection_noyank"
  'C-d "page_cursor_half_down"
  'C-D "page_cursor_down"
  'f "find_next_char"
  'F "find_prev_char"
  'g (hash
    'w "goto_word"
    'r "goto_reference"
    't "goto_type_definition"
    'i "goto_implementation"
    'd "goto_definition"
    'D "goto_declaration"
    'g "goto_file_start"
    'h "goto_first_nonwhitespace"
    'H "goto_line_start"
    'j "move_line_down"
    'J "goto_window_bottom"
    'k "move_line_up"
    'K "goto_window_top"
    'l "goto_line_end"
    'L "goto_line_end_newline"
    'x "goto_window_center"
    "." "goto_last_modification")
  'G "goto_last_line"
  'h "move_char_left"
  'j "move_visual_line_down"
  'J '("move_visual_line_down" "scroll_down")
  'k "move_visual_line_up"
  'K '("move_visual_line_up" "scroll_up")
  'l "move_char_right"
  'ç (hash
    'r "rename_symbol"
    's "select_references_to_symbol_under_cursor"
    'f "format_selections"
    'ç "code_action")
  'Ç "select_register"
  'z (hash
    'j "scroll_down"
    'J "align_view_top"
    'k "scroll_up"
    'K "align_view_bottom"
    'x "align_view_center"
    'v "align_view_middle")
  'x "extend_line_below"
  'X "extend_line_above"
  'C-x '("ensure_selections_forward" "select_line_above")
  'C-X '("ensure_selections_forward" "flip_selections" "select_line_below")
  'c "change_selection_noyank"
  'C-c "toggle_comments"
  'v "select_mode"
  'b "flip_selections"
  'B "ensure_selections_forward"
  'n "search_next"
  'N "search_prev"
  'm (hash
    'q "@miW"
    'w "@miw"
    'e "@<C-e><S-e>e"
    'r "surround_replace"
    'i "select_textobject_inner"
    'o "select_textobject_around"
    'a "surround_add"
    'd "surround_delete"
    'h "extend_to_first_nonwhitespace"
    'H "extend_to_line_start"
    'l "extend_to_line_end"
    'L "extend_to_line_end_newline"
    'x "extend_to_line_bounds"
    'X "shrink_to_line_bounds"
    'm "match_brackets"
    "." "repeat_last_motion")
  'C-m "replay_macro"
  'C-M "record_macro"
  "," "keep_primary_selection"
  '< "unindent"
  '> "indent"
  ";" "collapse_selection"
  ': "command_mode"
  '/ "search"
  '? "rsearch"
  'space (hash
    'tab "buffer_picker"
    'e "file_explorer_in_current_directory"
    'E "file_explorer"
    'C-e "file_explorer_in_current_buffer_directory"
    's "symbol_picker"
    'S "workspace_symbol_picker"
    'd "diagnostics_picker"
    'D "workspace_diagnostics_picker"
    'f "file_picker_in_current_directory"
    'F "file_picker"
    'C-f "file_picker_in_current_buffer_directory"
    'g "changed_file_picker"
    'z "suspend"
    ': (hash
      'o "@:open <C-r>%"
      'g "@:cd <C-r>%"
      'm "@:mv <C-r>%")
    '/ "global_search"
    '? "command_palette"
    'backspace "jumplist_picker")
  'down "scroll_down"
  'up "scroll_up"
  'backspace (hash
    'backspace "save_selection"
    'p "jump_backward"
    'n "jump_forward")
  'ret (hash
    'q "wclose"
    'ret "rotate_view"
    'o "wonly"
    's "hsplit"
    'h "jump_view_left"
    'H "swap_view_left"
    'j "jump_view_down"
    'J "swap_view_down"
    'k "jump_view_up"
    'K "swap_view_up"
    'l "jump_view_right"
    'L "swap_view_right"
    'v "vsplit")))

(define insert-mode (hash
  'esc "normal_mode"
  'tab "smart_tab"
  'S-tab "insert_tab"
  'C-r "insert_register"
  'C-u "commit_undo_checkpoint"
  'C-d "delete_char_forward"
  'C-D "kill_to_line_end"
  'C-h "move_char_left"
  'C-j "move_visual_line_down"
  'C-k "move_visual_line_up"
  'C-l "move_char_right"
  'C-x "completion"
  'C-/ '("signature_help" "hover")
  'ret "insert_newline"
  'down "scroll_down"
  'up "scroll_up"
  'backspace "delete_char_backward"
  'S-backspace "delete_char_backward"
  'C-backspace "delete_word_backward"
  'C-S-backspace "kill_to_line_start"))


(define (normal->select value)
  (define command-map (hash
    "select_mode"                 "exit_select_mode"
    "move_char_left"              "extend_char_left"
    "move_visual_line_down"       "extend_visual_line_down"
    "move_visual_line_up"         "extend_visual_line_up"
    "move_char_right"             "extend_char_right"
    "move_line_down"              "extend_line_down"
    "move_line_up"                "extend_line_up"
    "move_prev_long_word_start"   "extend_prev_long_word_start"
    "move_next_long_word_start"   "extend_next_long_word_start"
    "move_prev_long_word_end"     "extend_prev_long_word_end"
    "move_next_long_word_end"     "extend_next_long_word_end"
    "move_prev_sub_word_start"    "extend_prev_sub_word_start"
    "move_next_sub_word_start"    "extend_next_sub_word_start"
    "move_prev_sub_word_end"      "extend_prev_sub_word_end"
    "move_next_sub_word_end"      "extend_next_sub_word_end"
    "move_prev_word_start"        "extend_prev_word_start"
    "move_next_word_start"        "extend_next_word_start"
    "move_prev_word_end"          "extend_prev_word_end"
    "move_next_word_end"          "extend_next_word_end"
    "move_parent_node_start"      "extend_parent_node_start"
    "move_parent_node_end"        "extend_parent_node_end"
    "goto_first_nonwhitespace"    "extend_to_first_nonwhitespace"
    "goto_file_start"             "extend_to_file_start"
    "goto_file_end"               "extend_to_file_end"
    "goto_line_end"               "extend_to_line_end"
    "goto_last_line"              "extend_to_last_line"
    "find_next_char"              "extend_next_char"
    "find_prev_char"              "extend_prev_char"
    "find_till_char"              "extend_till_char"
    "till_prev_char"              "extend_till_prev_char"
    "goto_word"                   "extend_to_word"
    "goto_line_start"             "extend_to_line_start"
    "goto_line_end_newline"       "extend_to_line_end_newline"
    "search_next"                 "extend_search_next"
    "search_prev"                 "extend_search_prev"))
  (define (transform-command str)
    (define new-value-or-false
      (hash-try-get command-map str))
    (if (not new-value-or-false)
      str
      new-value-or-false))
  (cond
    ((string? value)
      (transform-command value))
    ((list? value)
      (map transform-command value))
    ((hash? value)
      (transduce value
        (mapping (lambda (lst)
          (define key (list-ref lst 0))
          (define value (list-ref lst 1))
          (list key (normal->select value))))
        (into-hashmap)))
    (else value)))


(define select-mode (hash-union
  (normal->select normal-mode)
  (hash
    "esc" "normal_mode")))


(cfg.set-keybindings!
  (~> (hash 'normal normal-mode 'insert insert-mode 'select select-mode)
    (value->jsexpr-string)
    (keymaps.helix-string->keymap)))
