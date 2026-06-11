function! AlignToEnd()
  let l:target = &textwidth > 0 ? &textwidth : 80
  let l:comment_len = strlen(getline('.')[col('.') - 1:])
  let l:spaces = l:target - virtcol('.') - l:comment_len + 1
  if l:spaces > 0
    execute 'normal! i' . repeat(' ', l:spaces) . "\<Esc>"
  endif
endfunction
nnoremap <leader>e :call AlignToEnd()<CR>
