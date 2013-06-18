" Pathogen {{{
    execute pathogen#infect()
" }}}

" Basics {{{
    set nocompatible
    set background=dark
" }}}

" General {{{
    filetype plugin indent on	" automatically detect filetypes
    syntax enable               " syntax highlighting

    if has("mouse")
        set mouse=a	            " enable mouse automatically
    endif
" }}}

" Vim UI {{{
    set showmode	            " display current mode
    set cursorline              " underline the line that the cursor is on
    set nu	                    " line numbers on
    set showmatch	            " matching brackets and parenthesis
    set ignorecase	            " case insensitive search
    set smartcase	            " case sensitive when uc characters present in 
                                " regex
    set scrolljump=5	        " lines to scroll when cursor leaves screen
    set scrolloff=3	            " min lines to keep above and below cursor

    if has("cmdline_info")
        set ruler
    endif

    if has("extra_search")
        set incsearch	        " search as you type
    endif

    if has("wildmenu")
        set wildmenu	        " show list instead of just completing
        set wildmode=list:longest,full	" command <Tab> completion
    endif
" }}}

" Formatting {{{
    set smartindent
    set autoindent
    set smarttab        " <Tab> inserts [shiftwidth] spaces
    set shiftwidth=4	" indent 4 spaces when using autoindent
    set softtabstop=4   " backspace deletes tabs
    set tabstop=4       " number of spaces that a tab counts for
    set expandtab       " tabs are spaces, not tabs
    set wmh=0           " min window height for when buffers are minimized

    if has("folding")
        set foldenable
        set foldmethod=marker
    endif

    " file specifc folding
    au BufWinEnter *.php let php_folding=1


    " highlight column 80
    if version >= 703 && has("syntax")
        set colorcolumn=80
    elseif version >= 701
        au BufWinEnter * let w:m1=matchadd('Search', '\%<81v.\%>77v', -1)
        au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)	
    else
        au BufRead,BufNewFile * syntax match Search /\%<81v.\%>77v/
        au BufRead,BufNewFile * syntax match ErrorMsg /\%>80v.\+/	
    endif
" }}}

" Plugins {{{
    " Vim Notes {{{
        let g:notes_directories=['~/Documents/notes']
    " }}}

    " NerdTree {{{
        au VimEnter * NERDTree  " open NERDTree
        au VimEnter * wincmd p
    " }}}

    " Tagbar {{{
        au VimEnter *.java,*.php,*.py :TagbarOpen
    " }}}

    " Tagbar phpctags {{{
        let g:tagbar_phpctags_bin='~/vim-helpers/vim-plugin-tagbar-phpctags/bin/phpctags'
    " }}}
" }}}

" Maps {{{
    nmap <F8> :NERDTreeToggle<CR>
    nmap <F9> :TagbarToggle<CR>
    inoremap ;; <ESC>
    
    " Windows {{{
        nmap <C-J> <C-W>j<C-W>_
        nmap <C-K> <C-W>k<C-W>_
        nmap <C-H> <C-W>h<C-W>
        nmap <C-L> <C-W>l<C-W>
    " }}}
" }}}
