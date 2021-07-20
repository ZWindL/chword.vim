" Begining of this amazing plugin

if exists("g:chword_loaded")
    finish
endif
let g:chword_loaded = "0.0.2"
let s:save_cpoptions = &cpoptions
set cpo&vim

function! s:mapKeys() abort
    " 键绑定写法需要精简
    " bind moving commands
    nnoremap <silent> <expr> w chword#exe('w', 0)
    nnoremap <silent> <expr> W chword#exe('W', 0)
    nnoremap <silent> <expr> b chword#exe('b', 0)
    nnoremap <silent> <expr> B chword#exe('B', 0)
    nnoremap <silent> <expr> e chword#exe('e', 0)
    nnoremap <silent> <expr> E chword#exe('E', 0)

    vnoremap <silent> <expr> w chword#exe('w', 0)
    vnoremap <silent> <expr> W chword#exe('W', 0)
    vnoremap <silent> <expr> b chword#exe('b', 0)
    vnoremap <silent> <expr> B chword#exe('B', 0)
    vnoremap <silent> <expr> e chword#exe('e', 0)
    vnoremap <silent> <expr> E chword#exe('E', 0)

    " 以下绑定方式不起作用，原因可能是 s:init() 被多次调用
    " let movings = ['w', 'W', 'b', 'B', 'e', 'E']
    " let pendings = ['a', 'i', 'A', 'i']
    "for moving in movings
    "    silent! execute printf("nnoremap <silent> <expr> %s chword#exe('%s', 0)", moving, moving)
    "    silent! execute printf("vnoremap <silent> <expr> %s chword#exe('%s', 0)", moving, moving)
    "endfor
    " bind pending commands
    "for pending in pendings
    "    silent! execute printf("omap <expr> <unique> %s chword#exe('%s', 1)", pending, pending)
    "    silent! execute printf("xmap <expr> <unique> %s chword#exe('%s', 1)", pending, pending)
    "endfor
    " bind @(chword) to the operation executor
    "nnoremap <silent> @(chword) :<C-U>call chword#do()<CR>
    "vnoremap <silent> @(chword) :<C-U>call chword#do()<CR>

    "onoremap <silent> @(chword) :<C-U>call chword#do()<CR>
endfunction

function! s:init() abort
    " init dict files
    " init settings
    " load dict files
    " bind keys
    echo 'initing'
    call chdict#init()
    call s:mapKeys()
    echo getcwd()
endfunction

call s:init()

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
