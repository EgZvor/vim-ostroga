function! s:intersperse_with_newlines(lines)
    let sep = ""
    return range(len(a:lines) * 2 - 1)
        \ ->map({_, val -> (val % 2 == 0 ? a:lines[val / 2] : sep)})
endfunction

function! s:mark_as_path(mark_info)
    return fnamemodify(a:mark_info.file, ':~:.')
endfunction

function! ostroga#ui#marks_to_hints(marks)
    return a:marks
        \ ->sort({m1, m2 -> s:mark_as_path(m1) > s:mark_as_path(m2)})
        \ ->map({
            \ _, mark_info ->
            \ tolower(mark_info.mark[1:]) . ': ' . s:mark_as_path(mark_info)
        \})
        \ ->s:intersperse_with_newlines()
endfunction
