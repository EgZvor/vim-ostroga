function! s:in_current_file(marks)
    return a:marks->filter({_, mark_info -> fnamemodify(mark_info.file, ':p') == expand('%:p')})
endfunction

function! s:global_alpha_marks()
    return getmarklist()
        \ ->filter({_, mark_info -> mark_info.mark[1:] =~? '[[:alpha:]]'})
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

function! ostroga#update_global_marks()
    for info in s:global_alpha_marks()
        \ ->s:in_current_file()
        exe 'normal! m' . info.mark[1:]
    endfor
endfunction

" TODO: Add fallback for neovim compatible popup
function! ostroga#popup_create()
    return popup_create(ostroga#ui#marks_to_hints(s:global_alpha_marks()), {
        \ 'filter': function('s:choose_mark'),
        \
        \ 'title': '  Jump to mark',
        \ 'border': [1, 1, 1, 1],
        \ 'borderchars': ['┈', '⸽', '┈', '⸽', '✨', '✨', '✨', '✨'],
        \ 'mapping': v:false,
        \ 'highlight': 'Normal',
        \ 'borderhighlight': ['Statement'],
    \})
endfunction
