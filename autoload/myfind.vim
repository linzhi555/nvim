let g:myfind#version="autoload_test"
function! myfind#FindWord(word)

    "" 跳到单词
    let l:result =  search(a:word)
    if l:result == 0
       echo "找不到匹配!"
    else
        normal! e
        echo a:word
    end
endfunction

