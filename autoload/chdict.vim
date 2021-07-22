let s:dict = {}

" Need a function loading the word list from files
function! s:chdictLoadDicts(dictFiles) abort
    for dictFile in a:dictFiles
        let lines = readfile(dictFile)
        for line in lines
           let s:dict[line] = 1
        endfor
    endfor
endfunction

" get word list
function! chdict#getDict() abort
    return s:dict
endfunction

" check if a word is in dict
function! chdict#isChWord(word) abort
    "echomsg a:word
    return get(s:dict, a:word, 0) ==# 1
endfunction

function! chdict#init() abort
    " initialize the dictionary
    " load dict
    let g:chword_dict_files = get(g: ,'chword_dict_files', [expand('<sfile>:p:h:h'). "/dict.txt"])
    call s:chdictLoadDicts(g:chword_dict_files)    
endfunction
