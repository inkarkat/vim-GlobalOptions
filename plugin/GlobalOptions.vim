" GlobalOptions.vim: Turn global options into buffer- or window-local ones.
"
" DEPENDENCIES:
"   - GlobalOptions/Command.vim autoload script
"   - ingo/err.vim autoload script
"
" Copyright: (C) 2012-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	002	05-May-2014	Abort on error.
"	001	02-Jan-2013	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_GlobalOptions') || (v:version < 700)
    finish
endif
let g:loaded_GlobalOptions = 1

command! -nargs=* -complete=option SetBufferLocal if ! GlobalOptions#Command#BufferLocal(<q-args>) | echoerr ingo#err#Get() | endif
command! -nargs=* -complete=option SetWindowLocal if ! GlobalOptions#Command#WindowLocal(<q-args>) | echoerr ingo#err#Get() | endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
