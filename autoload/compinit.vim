"======================================================================
"
" compinit.vim - general purpose completion library
"
" Created by skywind on 2023/08/03
" Last Modified: 2023/08/03 22:01:03
"
"======================================================================


"----------------------------------------------------------------------
" context before cursor
"----------------------------------------------------------------------
function! compinit#get_context() abort
	return strpart(getline('.'), 0, col('.') - 1)
endfunc


