" Saves the fileen vimrc is edited, reload it
autocmd! bufwritepost vimrc source ~/.vim_runtime/vimrc

syntax on

set linespace=1

set autoindent
set smartindent

" Size of a hard tabstop
set tabstop=4
" Size of an indent
set shiftwidth=4

set softtabstop=4
" Always use spaces instead of tab character
"set expandtab"
" Make tab insert indents instead of tab at beginning of lines
set smarttab

" Turn numbering on
set number

"""""""""""""""""""""FOLDING""""""""""""""""""
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

set cursorline		"highlight current line

set list		"show tabs and end of lines
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮

set ruler
set wildmenu
set wildmode=list:longest,full

set mouse=a

set showcmd 		"display incomplete tabs

set hlsearch		"highlight search
set backspace=indent,eol,start  " backspace through everything in insert mode
set incsearch		"Search incrementally
set ignorecase		"Searches are case insensitive...
set smartcase		" ... unless they contain at least one capital letter

colorscheme elflord
set cmdheight=2 	"The commandbar height

set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ (%p%%)]	"Informative status line
set showmatch		"show matching brackets

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

"Persistent undo
try
	if MySys() == "windows"
		set undodir=C:\Windows\Temp
	else
		set undodir=~/.vim_runtime/undodir
        endif

	set undofile
catch
endtry

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/
""""""""""""""""""""""""""""""""""""""""""""""""
" My Key Mappings
""""""""""""""""""""""""""""""""""""""""""""""""
map <f2> :w<cr> "f2 saves the file
map <F5> :setlocal spell! spelllang=en_us<CR>
" Remove trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e
