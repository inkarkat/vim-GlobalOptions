GLOBAL OPTIONS
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

For some Vim options, it may be helpful to make a particular setting only for
certain buffers or windows. Some options offer this, but when the option is
only globally scoped, this cannot be easily done.
For example, the 'scrolloff' option can be set to a high value to effectively
center the current line in the middle of the window. But one may only want
this for certain filetypes, or only in a particular window.

### HOW IT WORKS

When a buffer- or window-local global option is set, autocmds are set up that
modify the global option depending on the currently active buffer / window.
Because there can be buffer-local autocmds, but not window-local ones, the
approach taken is slightly different.

USAGE
------------------------------------------------------------------------------

    :SetBufferLocal
                            Show all global options made buffer-local.
    :SetBufferLocal {option}?
                            Show the buffer-local value of global {option} (if
                            set).
    :SetBufferLocal {option}={value}
                            Set the global {option} to {value}, but only in the
                            current buffer. Effectively turns {option} into a
                            buffer-local option.
    :SetBufferLocal {option}<
                            Remove the buffer-local value of {option}, so that the
                            global value will be used. Like :setlocal {option}<

    :SetWindowLocal
                            Show all global options made window-local.
    :SetWindowLocal {option}?
                            Show the window-local value of global {option} (if
                            set).
    :SetWindowLocal {option}={value}
                            Set the global {option} to {value}, but only in the
                            current window. Effectively turns {option} into a
                            window-local option.
    :SetWindowLocal {option}<
                            Remove the window-local value of {option}, so that the
                            global value will be used. Like :setlocal {option}<

    Alternatively, you can also directly use the following API functions.
    Note that these do less error checking than above commands.
    GlobalOptions#SetBufferLocal({option}, {value})
    GlobalOptions#ClearBufferLocal({option})
    GlobalOptions#SetWindowLocal({option}, {value})
    GlobalOptions#ClearWindowLocal({option})

### EXAMPLE

Place the current line in the middle of the window by setting 'scrolloff' (a
global option) to a large value, but only for the current window:

    :SetWindowLocal scrolloff=999

Place the current line in the middle of the window by setting 'scrolloff' (a
global option) to a large value, but only for a certain filetype (best placed
into ~/.vim/ftplugin/{filetype}.vim):

    :call GlobalOptions#SetBufferLocal('scrolloff', 999)
    :let b:undo_ftplugin = 'call GlobalOptions#ClearBufferLocal("scrolloff")'

Note that we use the API function in the undo command to avoid an error when
the buffer-local option has already been unset. (And also for setting it, to
be consistent and because it's slightly more efficient.)

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-GlobalOptions
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim GlobalOptions*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.009 or
  higher.

LIMITATIONS
------------------------------------------------------------------------------

- The plugin's correct operation depends on the execution of its autocmds.
  Mappings or other plugins that modify 'eventignore' or issue commands with
  :noautocmd can disturb this.
- Similarly, functionality that saves / restores windows (e.g. ZoomWin) might
  mess with the window-local plugin variable. Same might apply to session save
  and restore.

### CONTRIBUTING

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-GlobalOptions/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### 1.00    25-Jan-2013
- First published version.

##### 0.01    26-Dec-2012
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2012-2022 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
