"======================================================================
"
" comptask.vim - 
"
" Created by skywind on 2023/08/03
" Last Modified: 2023/08/03 22:12:27
"
"======================================================================


"----------------------------------------------------------------------
" internal
"----------------------------------------------------------------------
let s:comp_context = ''
let s:comp_strip = ''
let s:comp_head = ''
let s:comp_done = 0
let s:comp_items = []


"----------------------------------------------------------------------
" texts
"----------------------------------------------------------------------

" key names
let s:text_keys = {
			\ 'command': 'shell command, or EX-command (starting with :)',
			\ 'cwd': "working directory, use `:pwd` when absent",
			\ 'output': '"quickfix" or "terminal"',
			\ 'pos': 'terminal position or the name of a runner', 
			\ 'errorformat': 'error matching rules in the quickfix window',
			\ 'save': 'whether to save modified buffers before task start',
			\ 'option': 'arbitrary string to pass to the runner',
			\ 'focus': 'whether to focus on the task terminal',
			\ 'close': 'to close the task terminal when task is finished',
			\ 'program': 'command modifier',
			\ 'notify': 'notify a message when task is finished',
			\ 'strip': 'trim header+footer in the quickfix',
			\ 'scroll': 'is auto-scroll allowed in the quickfix',
			\ 'encoding': 'task stdin/stdout encoding',
			\ 'once': 'buffer output and flush when job is finished',
			\ }

let s:text_system = {
			\ 'win32': 'Windows',
			\ 'linux': 'Linux',
			\ 'darwin': 'macOS',
			\ }

" echo compinit#prefix_search('', s:text_keys, 'k', 1)

"----------------------------------------------------------------------
" complete key name
"----------------------------------------------------------------------
function! s:complete_keys(head)
	return compinit#prefix_search(a:head, s:text_keys, 'k', 1)
endfunc


"----------------------------------------------------------------------
" complete context
"----------------------------------------------------------------------
function! comptask#complete(context) abort
	let s:comp_context = a:context
	let s:comp_strip = substitute(a:context, '^\s*', '', '')
	let s:comp_done = 0
	let s:comp_head = ''
	let s:comp_items = []
	let context = a:context
	if compinit#check_space(context)
		return -1
	endif
	if s:comp_strip =~ '^['
		return 0
	elseif s:comp_strip =~ '^#'
		return 0
	elseif s:comp_strip =~ '^;'
		return 0
	elseif stridx(s:comp_strip, '=') < 0
		let s:comp_head = matchstr(context, '\w\+$')
		if s:comp_head == ''
			return 0
		endif
		if stridx(s:comp_strip, ':') < 0
			let s:comp_items = s:complete_keys(s:comp_head)
		elseif stridx(s:comp_strip, '/') < 0
			let s:comp_items = s:complete_filetype(s:comp_head)
		else
			let s:comp_items = s:complete_uname(s:comp_head)
		endif
		return len(s:comp_items)
	endif
	return 0
endfunc


"----------------------------------------------------------------------
" compfunc 
"----------------------------------------------------------------------
function! comptask#compfunc(findstart, base) abort
	if a:findstart
		let ctx = asclib#mcm#context()
		let matched = strchars(matchstr(ctx, '\w\+$'))
		let pos = col('.')
		if ctx =~ '^\s*#'
			let start = pos - 1
		elseif ctx =~ '^\s*['
			let start = pos - 1
		elseif stridx(ctx, '=') < 0
			let start = pos - matched - 1
		else
			if ctx =~ '\$$'
				let start = pos - 1 - 1
			elseif ctx =~ '\$($'
				let start = pos - 2 - 1
			elseif ctx =~ '\$(\w\+$'
				let start = pos - 2 - matched - 1
			else
				let start = pos - matched - 1
			endif
		endif
		return start
	else
		let ctx = compinit#context()
		if ctx =~ '^\s*#'
			return v:none
		elseif ctx =~ '^\s*['
			return v:none
		elseif stridx(ctx, '=') < 0
			if stridx(ctx, ':') < 0
				return asclib#mcm#match_complete(a:base, s:text_keys, 'k', 1)
			elseif stridx(ctx, '/') < 0
			else
			endif
		else
		endif
		return v:none
	endif
endfunc


