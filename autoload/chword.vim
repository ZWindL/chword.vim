function! s:isCh(sentence) abort
    let charcode = char2nr(a:sentence)
    return charcode >=# 19968 && charcode <=# 40869
endfunction

" 返回 <cword> 内容与 cursor 在 cword 中的相对位置
function! s:cword() abort
    let word = expand('<cword>')
    let rst = {'cword': word}
    
    " 设置当前位置信息
    let rst['pos']= getcursorcharpos()

    " 计算 cursor 相对位置
    let col = charcol('.')
    if col ==# 1
        let rst['offset'] = 0
    else
        execute "normal! b"
        let beginning = charcol('.')
        let rst['offset'] = col - beginning
        call setcharpos('.', rst['pos'])
    endif
    return rst
endfunction

" 求出第一个中文词汇的长度
function! s:lenOf1stWord(sentence) abort
    " 只需要分割第一个词即可，考虑下各种情况，句首、句尾等
    " 句尾直接把控制权交给 vim ，比如 '测试，ab'
    " 当 cursor 在 '试' 上面时，按下 w, 让 vim 来跳转即可
    " 词最长 6 个字
    " TODO: 加入贪心/非贪心的控制选项
    let maxWordLen = 6
    let chars = []
    for c in a:sentence
        let chars = add(chars, c)
        if chdict#isChWord(join(chars, ''))
            return len(chars)
        endif
        if maxWordLen < 1
            break
        endif
        let maxWordLen -= 1
    endfor
    return 1
endfunction

" 求出第一个中文词汇的长度（反向）
function! s:lenOfLastWord(sentence) abort
    " TODO: 加入贪心/非贪心的控制选项
    let maxWordLen = 6
    let chars = []
    let i = strchars(a:sentence) - 1
    while maxWordLen > 0 && i >= 0
        let chars = [strcharpart(a:sentence, i, 1)] + chars
        if chdict#isChWord(join(chars, ''))
            return len(chars)
        endif
        if maxWordLen < 1
            break
        endif
        let maxWordLen -= 1
        let i -= 1
    endwhile
    return 1
endfunction

" 向前一个词
function! chword#w(W=0) abort
    let rawCommand = 'normal! w'
    if a:W ==# 1
        let rawCommand = 'normal! W'
    endif
    let maxWordLen = 6
    " 获取 <cword>
    let word = s:cword()
    if !s:isCh(word['cword'])
        execute rawCommand
        return
    endif
    " 如果已经在词尾，则交还控制权给 vim
    if strchars(word['cword']) ==# word['offset'] + 1
        execute rawCommand
        return
    endif
    " 切割光标后的部分
    let sentenceAfterCursor = strcharpart(word['cword'], word['offset'], maxWordLen)
    " 第一个中文词汇的长度
    let wordLen = s:lenOf1stWord(sentenceAfterCursor)
    " 移动 cursor
    let word['pos'][2] += wordLen
    call setcharpos('.', word['pos'])
endfunction

function! chword#W() abort
    call chword#w(1)
endfunction

" 移动到词尾
" 操作与 w 基本一致
function! chword#e(E=0) abort
    let rawCommand = 'normal! e'
    if a:E ==# 1
        let rawCommand = 'normal! E'
    endif
    let maxWordLen = 6
    " 获取 <cword>
    let word = s:cword()
    if !s:isCh(word['cword'])
        " 如果当前词汇非中文且未在 cword 结尾，交由 vim 处理
        " TODO: 这里可能考虑不全面，中外一同出现的地方会有 bug
        if strchars(word['cword']) !=# word['offset'] + 1
            execute rawCommand
            return
        endif
        " 否则先跳转到下一个词
        execute 'normal! w'
    endif
    " 处理在 cword 词尾的情况
    "if strchars(word['cword']) ==# word['offset'] + 1
    "    " 先使用 w 跳转到下一个 cword, 然后移动到词尾部
    "    execute 'normal! w'
    "    " 处理跳转到下一行并且 cword 只有一个字符的情况
    "    let nextWord = s:cword()
    "    if strchars(word['cword']) ==# word['offset'] + 1
    "        return
    "    endif
    "endif
    " 切割光标后的部分
    let sentenceAfterCursor = strcharpart(word['cword'], word['offset'], maxWordLen)
    " 第一个中文词汇的长度
    let wordLen = s:lenOf1stWord(sentenceAfterCursor)
    " 移动 cursor
    let word['pos'][2] += max([wordLen - 1, 1])
    call setcharpos('.', word['pos'])
endfunction

function! chword#E() abort
    call chword#e(1)
endfunction

" 向后一个词
function! chword#b(B=0) abort
    let rawCommand = 'normal! b'
    if a:B ==# 1
        let rawCommand = 'normal! B'
    endif
    let maxWordLen = 6
    " 获取 <cword>
    let word = s:cword()
    " TODO: 向前移动单词还存在问题，无法处理 "中文|abcd" 的情况
    " 如果非中文 且 没有处于 cword 词首
    if !s:isCh(word['cword']) "&& word['offset'] !=# 0
        execute rawCommand
        return
    endif
    " 切割光标前的部分
    let length = min([word['offset'] + 1, maxWordLen])
    let beginning = word['offset'] + 1 - length
    let sentenceBeforeCursor = strcharpart(word['cword'], beginning, length)
    " 前一个中文词汇的长度
    let wordLen = s:lenOfLastWord(sentenceBeforeCursor)
    " 移动 cursor
    let word['pos'][2] -= wordLen
    call setcharpos('.', word['pos'])
endfunction

function! chword#B() abort
    call chword#b(1)
endfunction

" pending calls
" TODO: pending commands
function! chword#pending() abort
endfunction

" preparing for calling corresponding function
function! chword#exe(operation, isPending) abort
    if a:isPending ==# 0
        return ":call chword#" . a:operation . "()\<CR>"
    else
        let s:call = "call chword#pending(" . ")"
        return "@(chword)"
    endif
endfunction

" inspired by targets.vim
function! chword#do() abort
    execute s:call
endfunction

