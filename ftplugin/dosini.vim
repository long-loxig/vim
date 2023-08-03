"======================================================================
"
" dosini.vim - 
"
" Created by skywind on 2023/08/03
" Last Modified: 2023/08/03 20:52:56
"
"======================================================================


"----------------------------------------------------------------------
" detect platform
"----------------------------------------------------------------------
let s:windows = has('win32') || has('win16') || has('win64') || has('win95')


"----------------------------------------------------------------------
" integrity check
"----------------------------------------------------------------------
if exists(':AsyncTask') != 2 || exists(':AsyncRun') != 2
	silent! exec "AsyncRun -mode=load"
	silent! exec "AsyncTask -load"
	if exists(':AsyncTask') != 2 || exists(':AsyncRun') != 2
		runtime! plugin/asyncrun.vim
		runtime! plugin/asynctasks.vim
		if exists(':AsyncTask') != 2 || exists(':AsyncRun') != 2
			finish
		endif
	endif
endif


"----------------------------------------------------------------------
" check task config
"----------------------------------------------------------------------
function! s:check_task_config()
	let config_name = get(g:, 'asynctasks_config_name', '.tasks')
	let rtp_config = get(g:, 'asynctasks_rtp_config', 'tasks.ini')
	if expand('%:t') == config_name
		return 1
	endif
	let filepath = expand('%:p')
	for dirname in split(&rtp, ',')
		let t = printf('%s/%s', dirname, rtp_config)
		if asyncrun#utils#path_equal(filepath, t) != 0
			" echom printf("test: '%s' '%s'", filepath, t)
			return 1
		endif
	endfor
	return 0
endfunc

if s:check_task_config() == 0
	finish
endif


"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------


