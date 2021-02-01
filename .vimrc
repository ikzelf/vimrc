set nocompatible
set modelines=5
set filetype=off                  " required
" set number
filetype plugin on
filetype plugin indent on    " required
set omnifunc=syntaxcomplete#Complete

" Enable folding
set foldmethod=indent
set foldlevel=99
set tags=.tags

set backspace=2		" allow backspacing over everything in insert mode
set shiftwidth=4
set tabstop=4                " tabstop
set wrapmargin=2                " wrap margin
set expandtab                  " expand tabs to spaces
set autoindent			" always set autoindenting on
set autowrite                  " auto write
silent! !git rev-parse --is-inside-work-tree >/dev/null 2>&1
if v:shell_error == 0
    set nobackup	  " let git handle this
else
    set bdir=~/vup        " backup directory
    set backup		  " keep a backup file
    "Make backup before overwriting the current buffer
    set writebackup
    "Meaningful backup name, ex: filename@2015-04-05.14:59
    au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")
endif

set viminfo=%,<800,'10,/50,:100,h,f0,n~/.viminfo
"           | |    |   |   |    | |  + viminfo file path
"           | |    |   |   |    | + file marks 0-9,A-Z 0=NOT stored
"           | |    |   |   |    + disable 'hlsearch' loading viminfo
"           | |    |   |   + command-line history saved
"           | |    |   + search history saved
"           | |    + files marks saved
"           | + lines saved each register (old name for <, vi6.2)
"           + save/restore buffer list
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('$VIM_CONFIG_HOME/.vim/plugged')
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
" Plug 'WolfgangMehner/bash-support'
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'neomake/neomake'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
" Plug 'itspriddle/vim-shellcheck'
Plug 'airblade/vim-gitgutter'
Plug 'dense-analysis/ale'
" Initialize plugin system
call plug#end()

" make crontab -e work
:au BufNewFile,BufRead crontab.* set nobackup nowritebackup

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
 syntax on
   set hlsearch
endif
filetype indent plugin on
if did_filetype()
      finish
endif
if getline(1) =~# '^#!.*/bin/env'
  let tokens = split(getline(1))
  if len(tokens) >= 2
    setfiletype tokens[1]
  endif
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

 " In text files, always limit the width of text to 78 characters
 autocmd BufRead *.txt set textwidth=78
 autocmd BufRead *.pck set syntax=sql filetype=sql
 autocmd BufRead *.pkh set syntax=sql filetype=sql
 autocmd BufRead *.pkg set syntax=sql filetype=sql
 autocmd BufRead *.py  set filetype=python

 augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For C and C++ files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd FileType *      set formatoptions=tcql nocindent comments&
  autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
  autocmd FileType python* set tabstop=4
                             \ softtabstop=4
                             \ shiftwidth=4
                             \ textwidth=79
                             \ expandtab
                             \ autoindent
                             \ fileformat=unix
                             \ number
                             \ encoding=utf-8
  autocmd BufWritePost *.cpp,*.h,*.c,*.sh,*.py call UpdateTags()
 augroup END

endif " has("autocmd")
:highlight Normal guibg=SteelBlue4
" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
    let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
            \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
      let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
        call append(line("$"), l:modeline)
      endfunction
      nnoremap <silent> <Leader>ml :call AppendModeline()<CR>



function! DelTagOfFile(file)
  let fullpath = a:file
  let cwd = getcwd()
  let tagfilename = cwd . "/.tags"
  let f = substitute(fullpath, cwd . "/", "", "")
  let f = escape(f, './')
  let cmd = 'sed -i "/' . f . '/d" "' . tagfilename . '"'
  let resp = system(cmd)
endfunction

function! UpdateTags()
  let f = expand("%:p")
  let cwd = getcwd()
  let tagfilename = cwd . "/.tags"
  let cmd = 'ctags -a -f ' . tagfilename . ' --c++-kinds=+p --fields=+iaS --extra=+q ' . '"' . f . '"'
  call DelTagOfFile(f)
  let resp = system(cmd)
endfunction

