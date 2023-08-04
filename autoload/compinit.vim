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


"----------------------------------------------------------------------
" check tailing space
"----------------------------------------------------------------------
function! compinit#check_space(context) abort
	return (a:context == '' || a:context =~ '\s\+$')? 1 : 0
endfunc


"----------------------------------------------------------------------
" search candidate
"----------------------------------------------------------------------
function! compinit#prefix_search(prefix, candidate, kind, sort) abort
	let prefix = a:prefix
	if type(a:candidate) == type({})
		let keys = keys(a:candidate)
		let matched = []
		for key in keys(a:candidate)
			if stridx(key, prefix) == 0
				call extend(matched, [key])
			endif
		endfor
		if a:sort
			call sort(matched)
		endif
		let output = []
		for key in matched
			let text = a:candidate[key]
			let item = {'word':key, 'kind': a:kind, 'menu':text}
			call extend(output, [item])
		endfor
		return output
	elseif type(a:candidate) == type([])
		let matched = []
		for item in a:candidate
			if type(item) == 1
				let name = item
				let text = ''
			elseif type(item) == 3
				let name = item[0]
				let text = item[1]
			else
				continue
			endif
			if stridx(name, prefix) == 0
				call extend(matched, [[name, text]])
			endif
		endfor
		if a:sort
			call sort(matched)
		endif
		let output = []
		for [name, text] in matched
			let item = {'word':key, 'kind': a:kind, 'menu':text}
			call extend(output, item)
		endfor
		return output
	endif
endfunc




