if exists('g:loaded_markslist')
    finish
endif

let g:loaded_markslist = 1

function! s:global_alpha_marks()
    return getmarklist()
        \ ->filter({_, mark_info -> mark_info.mark[1:] =~? '[[:alpha:]]'})
endfunction

function! s:intersperse_with_newlines(lines)
    let sep = ""
    return range(len(a:lines) * 2 - 1)
        \ ->map({_, val -> (val % 2 == 0 ? a:lines[val / 2] : sep)})
endfunction

function! s:mark_as_path(mark_info)
    return fnamemodify(a:mark_info.file, ':~:.')
endfunction

function! s:in_current_file(marks)
    return a:marks->filter({_, mark_info -> fnamemodify(mark_info.file, ':p') == expand('%:p')})
endfunction

function! s:update_global_marks()
    for info in s:global_alpha_marks()->s:in_current_file()
        exe 'normal! m' . info.mark[1:]
    endfor
endfunction

function! s:marks_to_hints(marks)
    return a:marks
        \ ->sort({m1, m2 -> s:mark_as_path(m1) > s:mark_as_path(m2)})
        \ ->map({
            \ _, mark_info ->
            \ tolower(mark_info.mark[1:]) . ': ' . s:mark_as_path(mark_info)
        \})
        \ ->s:intersperse_with_newlines()
endfunction

function! s:choose_mark(winid, key)
    if a:key =~? '[[:alpha:]]'
        exe 'silent! normal! `' . toupper(a:key)
        call popup_close(a:winid)
        return 1
    elseif a:key ==? "\<esc>"
        call popup_close(a:winid)
        return 1
    endif
    return 0
endfunction

command -nargs=0 OstrogaMark call popup_create(s:marks_to_hints(s:global_alpha_marks()), {
    \ 'filter': function('s:choose_mark'),
    \
    \ 'title': '  Jump to mark',
    \ 'border': [1, 1, 1, 1],
    \ 'borderchars': ['┈', '⸽', '┈', '⸽', '✨', '✨', '✨', '✨'],
    \ 'mapping': v:false,
    \ 'highlight': 'Normal',
    \ 'borderhighlight': ['Statement'],
\})

augroup ostroga_update_global_marks
    au!
    autocmd BufLeave * call s:update_global_marks()
augroup END
