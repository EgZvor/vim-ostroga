scriptencoding utf8

if exists('g:loaded_ostroga_plugin')
    finish
endif

let g:loaded_ostroga_plugin = 1

command -nargs=0 OstrogaJump call ostroga#popup_create()

augroup ostroga_update_global_marks
    au!
    autocmd BufLeave * call ostroga#update_global_marks()
augroup END
