"Basics
set nocompatible
set background=dark

"General	
filetype plugin indent on	" automatically detect filetypes
syntax enable               " syntax highlighting
set mouse=a	                " enable mouse automatically

" Vim UI
set showmode	            " display current mode
set cursorline              " underline the line that the cursor is on
set nu	                    " line numbers on
set showmatch	            " matching brackets and parenthesis
set ignorecase	            " case insensitive search
set smartcase	            " case sensitive when uc characters present in regex
set scrolljump=5	        " lines to scroll when cursor leaves screen
set scrolloff=3	            " min lines to keep above and below cursor

if has("extra_search")
    set incsearch	        " search as you type
endif

if has("wildmenu")
    set wildmenu	        " show list instead of just completing
    set wildmode=list:longest,full	" command <Tab> completion
endif

" Formatting
set autoindent      " indent at the same level of the previous line
set smarttab        " <Tab> inserts [shiftwidth] spaces
set shiftwidth=4	" indent 4 spaces when using autoindent
set softtabstop=4   " backspace deletes tabs
set tabstop=4       " number of spaces that a tab counts for
set expandtab       " tabs are spaces, not tabs

if has("folding")
    set foldenable
    set foldmethod=marker
endif

" file specifc folding
let php_folding = 1

if has("cmdline_info")
    set ruler
endif

if has("syntax")
    set colorcolumn=80
endif

" Vim Notes
if isdirectory("~/Documents/notes")
    let g:notes_directories=['~/Documents/notes']
endif
