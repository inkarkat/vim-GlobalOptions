" GlobalOptions/Command.vim: Implementation for :Set...Local commands.
"
" DEPENDENCIES:
"   - GlobalOptions.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/escape.vim autoload script
"
" Copyright: (C) 2012-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	003	05-May-2014	Abort on error.
"	002	15-Jun-2013	Replace s:Unescape() with generic
"				ingo#escape#Unescape().
"	001	02-Jan-2013	file creation

function! s:OptionCheck( parsedOption )
    if ! exists('&' . a:parsedOption[1])
	let a:parsedOption[0] = 'invalid'
    endif

    return a:parsedOption
endfunction
function! s:Parse( option )
    if a:option =~# '^no\a\+$'
	return s:OptionCheck(['set', a:option[2:], '0'])
    elseif a:option =~# '^\a\+$'
	return s:OptionCheck(['set', a:option, '1'])
    elseif a:option =~# '^\a\+?$'
	return s:OptionCheck(['list', a:option[0:-2], ''])
    elseif a:option =~# '^\a\+<$'
	return s:OptionCheck(['clear', a:option[0:-2], ''])
    elseif a:option =~# '^\a\+='
	let l:pos = stridx(a:option, '=')
	return s:OptionCheck(['set', strpart(a:option, 0, l:pos), ingo#escape#Unescape(strpart(a:option, l:pos + 1), '\ ')])
    else
	return ['invalid', a:option, '']
    endif
endfunction
function! s:ParseOptions( options )
    let l:options = split(a:options, '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<! ')
    return map(l:options, 's:Parse(v:val)')
endfunction


function! s:HasBufferLocalOption( option )
    return index(GlobalOptions#GetBufferLocals(), a:option) != -1
endfunction
function! s:ListBufferLocal( option )
    execute 'let l:value = &g:' . a:option
    echo printf('%s=%s', a:option, l:value)
endfunction
function! s:ListBufferLocals()
    for l:option in sort(GlobalOptions#GetBufferLocals())
	call s:ListBufferLocal(l:option)
    endfor
endfunction
function! GlobalOptions#Command#BufferLocal( options )
    if empty(a:options)
	call s:ListBufferLocals()
    else
	for [l:action, l:option, l:value] in s:ParseOptions(a:options)
	    if l:action ==# 'list'
		if s:HasBufferLocalOption(l:option)
		    call s:ListBufferLocal(l:option)
		endif
	    elseif l:action ==# 'set'
		call GlobalOptions#SetBufferLocal(l:option, l:value)
	    elseif l:action ==# 'clear'
		if ! s:HasBufferLocalOption(l:option)
		    call ingo#err#Set(printf('No buffer-local option: %s', l:option))
		    return 0
		endif

		call GlobalOptions#ClearBufferLocal(l:option)
	    elseif l:action ==# 'invalid'
		call ingo#err#Set(printf('Unknown option: %s', l:option))
		return 0
	    else
		throw 'ASSERT: Invalid action ' . string(l:action)
	    endif
	endfor
    endif

    return 1
endfunction


function! s:ListWindowLocal( option )
    if ! exists('w:GlobalWindowOptions') || ! has_key(w:GlobalWindowOptions, a:option)
	return
    endif

    echo printf('%s=%s', a:option, w:GlobalWindowOptions[a:option])
endfunction
function! s:ListWindowLocals()
    for l:option in sort(exists('w:GlobalWindowOptions') ? keys(w:GlobalWindowOptions) : [])
	call s:ListWindowLocal(l:option)
    endfor
endfunction
function! GlobalOptions#Command#WindowLocal( options )
    if empty(a:options)
	call s:ListWindowLocals()
    else
	for [l:action, l:option, l:value] in s:ParseOptions(a:options)
	    if l:action ==# 'list'
		call s:ListWindowLocal(l:option)
	    elseif l:action ==# 'set'
		call GlobalOptions#SetWindowLocal(l:option, l:value)
	    elseif l:action ==# 'clear'
		if ! exists('w:GlobalWindowOptions') || ! has_key(w:GlobalWindowOptions, l:option)
		    call ingo#err#Set(printf('No window-local option: %s', l:option))
		    return 0
		endif

		call GlobalOptions#ClearWindowLocal(l:option)
	    elseif l:action ==# 'invalid'
		call ingo#err#Set(printf('Unknown option: %s', l:option))
		return 0
	    else
		throw 'ASSERT: Invalid action ' . string(l:action)
	    endif
	endfor
    endif

    return 1
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
