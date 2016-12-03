" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible " must be first line
""Functions+Constants"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
silent function! OSX()
  return has('macunix')
endfunction
silent function! LINUX()
  return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! WINDOWS()
  return  (has('win32') || has('win64'))
endfunction
silent function! ResCur()
  if line("'\"") <= line("$")
    silent! normal! g`"
    return 1
  endif
endfunction
silent function! InitializeDirectories()
  let parent = $HOME
  let prefix = 'vim'
  let dir_list = {
              \ 'backup': 'backupdir',
              \ 'views': 'viewdir',
              \ 'swap': 'directory' }
  if has('persistent_undo')
      let dir_list['undo'] = 'undodir'
  endif

  let common_dir = '/wdrive/tmp/'

  for [dirname, settingname] in items(dir_list)
    let directory = common_dir . dirname . '/'
    if exists("*mkdir")
      if !isdirectory(directory)
        call mkdir(directory)
      endif
    endif
    if !isdirectory(directory)
      echo "Warning: Unable to create backup directory: " . directory
      echo "Try: mkdir -p " . directory
    else
      let directory = substitute(directory, " ", "\\\\ ", "g")
      exec "set " . settingname . "=" . directory
    endif
  endfor
endfunction
call InitializeDirectories()
silent function! NERDTreeInitAsNeeded()
  redir => bufoutput
  buffers!
  redir END
  let idx = stridx(bufoutput, "NERD_tree")
  if idx > -1
    NERDTreeMirror
    NERDTreeFind
    wincmd l
  endif
endfunction
silent function! StripTrailingWhitespace()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  %s/\s\+$//e
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
silent function! s:RunShellCommand(cmdline)
    botright new
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal noswapfile
    setlocal nowrap
    setlocal filetype=shell
    setlocal syntax=shell
    call setline(1, a:cmdline)
    call setline(2, substitute(a:cmdline, '.', '=', 'g'))
    execute 'silent $read !' . escape(a:cmdline, '%#')
    setlocal nomodifiable
    1
endfunction
command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
" e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
silent function! s:ExpandFilenameAndExecute(command, file)
  execute a:command . " " . expand(a:file, ":p")
endfunction
""Environment"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if WINDOWS()
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
  if has("multi_byte")
    set termencoding=cp850
    set encoding=utf-8
    setglobal fileencoding=utf-8
    set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15
  endif
endif
if !WINDOWS()
  set shell=/bin/bash
endif
""Bundles"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
""General
Plug 'bronson/vim-trailing-whitespace'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'Shougo/vimproc.vim'
Plug 'scrooloose/nerdtree'
Plug 'spf13/vim-colors'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'rhysd/conflict-marker.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tacahiroy/ctrlp-funky'
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-scripts/sessionman.vim'
Plug 'matchit.zip'
Plug 'powerline/fonts'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'flazz/vim-colorschemes'
Plug 'mbbill/undotree'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'mhinz/vim-signify'
Plug 'gcmt/wildfire.vim'
""writing
Plug 'junegunn/goyo.vim'
""programming
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/syntastic'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-commentary'
Plug 'godlygeek/tabular'
"Plug 'luochen1990/rainbow'
if executable('ctags')
Plug 'majutsushi/tagbar'
endif
Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'
""python
" Pick either python-mode or pyflakes & pydoc
Plug 'klen/python-mode'
Plug 'yssource/python.vim'
Plug 'python_match.vim'
Plug 'pythoncomplete'
""javascript
Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'maksimr/vim-jsbeautify'
Plug 'einars/js-beautify'
Plug 'elzr/vim-json'
Plug 'groenewege/vim-less'
Plug 'briancollins/vim-jst'
""scala
Plug 'derekwyatt/vim-scala'
Plug 'derekwyatt/vim-sbt'
Plug 'xptemplate'
""haskell
Plug 'travitch/hasksyn'
Plug 'dag/vim2hs'
Plug 'Twinside/vim-haskellConceal'
Plug 'Twinside/vim-haskellFold'
Plug 'lukerandall/haskellmode-vim'
Plug 'eagletmt/neco-ghc'
Plug 'eagletmt/ghcmod-vim'
Plug 'adinapoli/cumino'
Plug 'bitc/vim-hdevtools'
""html
Plug 'amirh/HTML-AutoCloseTag'
Plug 'hail2u/vim-css3-syntax'
Plug 'gorodinskiy/vim-coloresque'
Plug 'tpope/vim-haml'
Plug 'mattn/emmet-vim'
Plug 'othree/xml.vim'
""ruby
Plug 'tpope/vim-rails'
let g:rubycomplete_buffer_loading = 1
"let g:rubycomplete_classes_in_global = 1
"let g:rubycomplete_rails = 1
""puppet
Plug 'rodjek/vim-puppet'
""go-lang
"Plug 'Blackrush/vim-gocode'
Plug 'fatih/vim-go'
""elixir
Plug 'elixir-lang/vim-elixir'
Plug 'carlosgaldino/elixir-snippets'
Plug 'mattreduce/vim-mix'
""clojure
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'kien/rainbow_parentheses.vim'
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-fireplace'
"Plug 'paredit.vim'
"Plug 'tpope/vim-classpath'
"Plug 'jpalardy/vim-slime'
""ag
Plug 'rking/ag.vim'
""elm-lang
Plug 'lambdatoast/elm.vim'
""misc
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-markdown'
Plug 'spf13/vim-preview'
Plug 'tpope/vim-cucumber'
Plug 'cespare/vim-toml'
Plug 'quentindecock/vim-cucumber-align-pipes'
Plug 'saltstack/salt-vim'
call plug#end()

""plugin-configs""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"--c++
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:syntastic_c_include_dirs = ['.','/wdrive/games/cocos2d/ptr/cocos','/wdrive/myspace/fusilli/src/main/cpp/fusilli','/wdrive/myspace/fusilli/src/main/cpp/pong','/wdrive/myspace/fusilli/src/main/cpp']
"--Fugitive
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
" Mnemonic _i_nteractive
nnoremap <silent> <leader>gi :Git add -p %<CR>
nnoremap <silent> <leader>gg :SignifyToggle<CR>
"--vim-gitgutter
highlight clear SignColumn
highlight SignColumn ctermbg=0
nmap gn <Plug>GitGutterNextHunk
nmap gN <Plug>GitGutterPrevHunk
"--Frege
autocmd BufEnter *.fr :filetype haskell
"--clojure
autocmd BufEnter *.cljs,*.clj,*.cljs.hl RainbowParenthesesActivate
autocmd BufEnter *.cljs,*.clj,*.cljs.hl RainbowParenthesesLoadRound
autocmd BufEnter *.cljs,*.clj,*.cljs.hl RainbowParenthesesLoadSquare
autocmd BufEnter *.cljs,*.clj,*.cljs.hl RainbowParenthesesLoadBraces
autocmd BufNewFile,BufRead *.boot set filetype=clojure
autocmd BufNewFile,BufRead *.edn set filetype=clojure
" fix I don't know why
autocmd BufEnter *.cljs,*.clj,*.cljs.hl setlocal iskeyword+=?,-,*,!,+,/,=,<,>,.,:
" rainbow parenthesis options
let g:rbpt_colorpairs = [
  \ ['darkyellow',  'RoyalBlue3'],
  \ ['darkgreen',   'SeaGreen3'],
  \ ['darkcyan',    'DarkOrchid3'],
  \ ['Darkblue',    'firebrick3'],
  \ ['DarkMagenta', 'RoyalBlue3'],
  \ ['darkred',     'SeaGreen3'],
  \ ['darkyellow',  'DarkOrchid3'],
  \ ['darkgreen',   'firebrick3'],
  \ ['darkcyan',    'RoyalBlue3'],
  \ ['Darkblue',    'SeaGreen3'],
  \ ['DarkMagenta', 'DarkOrchid3'],
  \ ['Darkblue',    'firebrick3'],
  \ ['darkcyan',    'SeaGreen3'],
  \ ['darkgreen',   'RoyalBlue3'],
  \ ['darkyellow',  'DarkOrchid3'],
  \ ['darkred',     'firebrick3'],
  \ ]
"--js beautifer
autocmd FileType javascript noremap <buffer> <c-f> :call JsBeautify()<cr>
autocmd FileType html noremap <buffer> <c-f> :call JsBeautify()<cr>
autocmd FileType css noremap <buffer> <c-f> :call JsBeautify()<cr>
"--go-lang
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>e <Plug>(go-rename)
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <leader>co <Plug>(go-coverage)
"--ctags
set tags=./tags;/,~/.vimtags
" Make tags placed in .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
  let &tags = &tags . ',' . gitroot . '/.git/tags'
endif
"--autoCloseTag
" Make it so AutoCloseTag works for xml and xhtml files as well
au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
nmap <Leader>ac <Plug>ToggleAutoCloseMappings
"--nerdTree
map <C-e> <plug>NERDTreeTabsToggle<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>qq :NERDTreeFind<CR>
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0
let g:NERDShutUp=1
"--session list
set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
nmap <leader>sl :SessionList<CR>
nmap <leader>ss :SessionSave<CR>
nmap <leader>sc :SessionClose<CR>
"--json
nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
let g:vim_json_syntax_conceal = 0
"--PyMode
" Disable if python support not present
if !has('python') && !has('python3')
  let g:pymode = 0
endif
let g:pymode_lint_checkers = ['pyflakes']
let g:pymode_trim_whitespaces = 0
let g:pymode_options = 0
let g:pymode_rope = 0
"--ctrlp
let g:ctrlp_working_path_mode = 'ra'
nnoremap <silent> <D-t> :CtrlP<CR>
nnoremap <silent> <D-r> :CtrlPMRU<CR>
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\.git$\|\.hg$\|\.svn$',
    \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }
if executable('ag')
  let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
elseif executable('ack-grep')
  let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
elseif executable('ack')
  let s:ctrlp_fallback = 'ack %s --nocolor -f'
" On Windows use "dir" as fallback command.
elseif WINDOWS()
  let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
else
  let s:ctrlp_fallback = 'find %s -type f'
endif
if exists("g:ctrlp_user_command")
  unlet g:ctrlp_user_command
endif
let g:ctrlp_user_command = {
    \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
    \ 'fallback': s:ctrlp_fallback
\ }
" CtrlP extensions
let g:ctrlp_extensions = ['funky']
"funky
nnoremap <Leader>fu :CtrlPFunky<Cr>
"--TagBar
nnoremap <silent> <leader>tt :TagbarToggle<CR>
"--neocomplete
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#max_list = 15
let g:neocomplete#force_overwrite_completefunc = 1
" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
            \ }
" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
if !exists('g:spf13_no_neosnippet_expand')
  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)
endif
" <C-k> Complete Snippet
" <C-k> Jump to next snippet point
imap <silent><expr><C-k> neosnippet#expandable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
            \ "\<C-e>" : "\<Plug>(neosnippet_expand_or_jump)")
smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()
"inoremap <expr><CR> neocomplete#complete_common_string()
" <CR>: close popup
" <s-CR>: close popup and save indent.
inoremap <expr><s-CR> pumvisible() ? neocomplete#smart_close_popup()."\<CR>" : "\<CR>"
silent function! CleverCr()
  if pumvisible()
    if neosnippet#expandable()
      let exp = "\<Plug>(neosnippet_expand)"
      return exp . neocomplete#smart_close_popup()
    else
      return neocomplete#smart_close_popup()
    endif
  else
    return "\<CR>"
  endif
endfunction
" <CR> close popup and save indent or expand snippet
imap <expr> <CR> CleverCr()
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplete#smart_close_popup()
" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
" Courtesy of Matteo Cavalleri
silent function! CleverTab()
  if pumvisible()
    return "\<C-n>"
  endif
  let substr = strpart(getline('.'), 0, col('.') - 1)
  let substr = matchstr(substr, '[^ \t]*$')
  if strlen(substr) == 0
    " nothing to match on empty string
    return "\<Tab>"
  else
    " existing text matching
    if neosnippet#expandable_or_jumpable()
      return "\<Plug>(neosnippet_expand_or_jump)"
    else
      return neocomplete#start_manual_complete()
    endif
  endif
endfunction
imap <expr> <Tab> CleverTab()
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
"--Snippets
" Use honza's snippets.
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
" Enable neosnippet snipmate compatibility mode
let g:neosnippet#enable_snipmate_compatibility = 1
" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
" Enable neosnippets when using go
let g:go_snippet_engine = "neosnippet"
" Disable the neosnippet preview candidate window
" When enabled, there can be too much visual noise
" especially when splits are used.
set completeopt-=preview
" FIXME: Isn't this for Syntastic to handle?
" Haskell post write lint and check with ghcmod
" $ `cabal install ghcmod` if missing and ensure
" ~/.cabal/bin is in your $PATH.
if !executable("ghcmod")
  autocmd BufWritePost *.hs GhcModCheckAndLintAsync
endif
"--UndoTree
nnoremap <Leader>u :UndotreeToggle<CR>
" If undotree is opened, it is likely one wants to interact with it.
let g:undotree_SetFocusWhenToggle=1
"--indent_guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
"--Wildfire
let g:wildfire_fuel_map = get(g:, "wildfire_fuel_map", "<SPACE>")
let g:wildfire_objects = {
          \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
          \ "html,xml" : ["at"],
          \ }
"--vim-airline
if !exists('g:airline_theme')
  let g:airline_theme = 'solarized'
endif
if !exists('g:airline_powerline_fonts')
  " Use the default set of separators with a few customizations
  let g:airline_left_sep='›'  " Slightly fancier than '>'
  let g:airline_right_sep='‹' " Slightly fancier than '<'
endif
"--misc
autocmd BufNewFile,BufRead *.ftl set filetype=html
let b:match_ignorecase = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""
filetype plugin indent on   " Automatically detect file types.
scriptencoding utf-8
syntax on                   " Syntax highlighting
set mouse=a                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing
if has('clipboard')
  if has('unnamedplus') " When possible use + register for copy-paste
    set clipboard=unnamed,unnamedplus
  else " On mac and Windows, use * register for copy-paste
    set clipboard=unnamed
  endif
endif
" Always switch to the current file directory
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
"set autowrite     " Automatically write a file when leaving a modified buffer
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
set virtualedit=onemore             " Allow for cursor beyond last character
set history=1000                    " Store a ton of history (default is 20)
set nospell
set hidden                          " Allow buffer switching without saving
set iskeyword-=.                    " '.' is an end of word designator
set iskeyword-=#                    " '#' is an end of word designator
set iskeyword-=-                    " '-' is an end of word designator
" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END
set nobackup
set noswapfile
if has('persistent_undo')
  set undofile                " So is persistent undo ...
  set undolevels=1000         " Maximum number of changes that can be undone
  set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif
"--ui
set tabpagemax=15               " Only show 15 tabs
set showmode                    " Display the current mode
set cursorline                  " Highlight current line
highlight clear SignColumn      " SignColumn should match background
highlight clear LineNr          " Current line number row will have same background color in relative mode
"highlight clear CursorLineNr    " Remove highlight color from current line number
if has('cmdline_info')
  set ruler                   " Show the ruler
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
  set showcmd                 " Show partial commands in status line and
                              " Selected characters/lines in visual mode
endif
if has('statusline')
  set laststatus=2
  " Broken down into easily includeable segments
  set statusline=%<%f\                     " Filename
  set statusline+=%w%h%m%r                 " Options
  set statusline+=%{fugitive#statusline()} " Git Hotness
  set statusline+=\ [%{&ff}/%Y]            " Filetype
  set statusline+=\ [%{getcwd()}]          " Current dir
  set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif
set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set number                      " Line numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
"--formatting
set nowrap                      " Do not wrap long lines
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=2                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=2                   " An indentation every four columns
set softtabstop=2               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
"set matchpairs+=<:>             " Match, to be used with %
set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
"set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
autocmd FileType clojure,c,cpp,java,groovy,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('g:spf13_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
"autocmd FileType go autocmd BufWritePre <buffer> Fmt
autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
"autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
" Workaround vim-commentary for Haskell
autocmd FileType haskell setlocal commentstring=--\ %s
" Workaround broken colour highlighting in Haskell
autocmd FileType haskell,rust setlocal nospell
"--key (re)mappings
let mapleader = ','
let maplocalleader = '_'
" Easier moving in tabs and windows
" The lines conflict with the default digraph mapping of <C-K>
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-L> <C-W>l<C-W>_
map <C-H> <C-W>h<C-W>_
" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk
" Fast tabs
map <S-H> gT
map <S-L> gt
" Stupid shift key fixes
if has("user_commands")
  command! -bang -nargs=* -complete=file E e<bang> <args>
  command! -bang -nargs=* -complete=file W w<bang> <args>
  command! -bang -nargs=* -complete=file Wq wq<bang> <args>
  command! -bang -nargs=* -complete=file WQ wq<bang> <args>
  command! -bang Wa wa<bang>
  command! -bang WA wa<bang>
  command! -bang Q q<bang>
  command! -bang QA qa<bang>
  command! -bang Qa qa<bang>
endif
cmap Tabe tabe
" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$
" Code folding options
nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>
"nmap <silent> <leader>/ :nohlsearch<CR>
nmap <silent> <leader>/ :set invhlsearch<CR>
" Find merge conflict markers
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
" Shortcuts
" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h
" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>
" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null
" Some helpers to edit mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%
" Adjust viewports to the same size
map <Leader>= <C-w>=
" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
" Easier horizontal scrolling
map zl zL
map zh zH
" Easier formatting
nnoremap <silent> <leader>q gwip
" FIXME: Revert this f70be548
" fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>
""ui""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"osx_like
"fruity
"olive
"nuvola
"pencil
"summerfruit
"summerfruit256
"sonoma
"sienna
"neverland
"moria
"bubblegum
"badwolf
"autumn
"ashen
"zenburn
"yeller
"void
"tolerable
"seashell
""color clarity
"color torte
"color jellybeans
"color sift
"color xoria256
"color candycode
"color soruby
""color symfony
""color BlackSea
""color blazer
"color bluegreen
"color elisex
"color advantage
"color af
"color asu1dark
"color navajo-night
"color wombat256
"color desert256
""color molokai
"color corn
""color fruity
"color herald
""color jammy
"color mint
"color thegoodluck
""color codeschool
"color spectro
    ""color solarized
"color darkblue2
"color darktango
"color desertedoceanburnt
"color simplewhite
"color materialtheme
"color frozen
"color oxeded
"color feral
"color monochrome
"color abbott
"color sandydune
"color herokudoc-gvim
"color mopkai
let has_colors=1
if exists('has_colors')
if LINUX()
  "color summerfruit
  color zellner
elseif OSX()
  "color yeller
  "color sand
  "color beachcomber
  "color blackboard
  "color simplewhite
  "color shobogenzo
  "color desertedoceanburnt
  "color corporation
  "color zellner
  "color robinhood
  "color bensday
  "color metacosm
  "color torte
  "color wolfpack
  "color underwater
  "color clarity
  "color summerfruit
  "color solarized
  "color default
  "color yeller
  "color neon
  "color strawimodo
  "color proton
  "color xoria256
  "color mint
  "color whitebox
  "color seashell
  "color nuvola
  "color codeschool
  "color github
  "color sonoma
  color default
  "color eclipse

elseif WINDOWS()
  color zellner
endif
endif


if has('gui_running')
  if LINUX()
    "set guifont=Andale\ Mono\ Regular\ 16,Menlo\ Regular\ 15,Consolas\ Regular\ 16,Courier\ New\ Regular\ 18
    "set gfn=Calculator\ Regular\ 20
    "set gfn=AylaCSscript\ Regular\ 12
    "set gfn=hlmt-rounded\ Regular\ 14
    "set gfn=Teenage\ angst\ 16
    "set gfn=Mistress\ Bold\ 20
    "set gfn=Calculator\ 16
    "set gfn=DJB\ Sissy\ Regular\ 12
    "set gfn=What's\ Love?\ Konnamozi\ Regular\ 12
    "set gfn=DJB\ Elliephont\ Bold\ 8
    "set gfn=proportional\ tfb\ Regular\ 10
    "set gfn=Lekton\ Regular\ 13
    "set gfn=BPmono\ Regular\ 13
    "set gfn=CamingoCode\ Regular\ 13
    "set gfn=Belshaw\ Donut\ Robot\ Regular\ 13
    "set gfn=Soul\ Lotion\ Regular\ 13
    "set gfn=Sornette\ Regular\ 12
    "set gfn=Giorgino\ Regular\ 12
    "set gfn=Gordon\ Heights\ 10
    "set gfn=fresh\ Regular\ 14
    "set gfn=kowalski\ Regular\ 14
    "set gfn=MixLean\ Medium\ 14
    "set gfn=Chicken\ Scratch\ Regular\ 12
    "set gfn=Retrievse\ NC\ Regular\ 12
    "set gfn=thin\ lines\ and\ curves\ 12
    "set gfn=RetroRocket\ Medium\ 20
  elseif OSX()
    "set guifont=Andale\ Mono\ Regular:h16,Menlo\ Regular:h15,Consolas\ Regular:h16,Courier\ New\ Regular:h18
    "set gfn=Linden\ Hill:h24
    "set gfn=M+\ 1mn:h18
    "set gfn=Tall\ &\ Lean:h24
    "set gfn=Tenderness:h18
    "set gfn=hlmt-rounded:h20
    "set gfn=FP\ second\ hand:h20
    "set gfn=Teenage\ angst:h20
    "set gfn=DJB\ Sissy:h20
    "set gfn=Florence:h24
    "set gfn=kowalski:h24
    "set gfn=MixLean:h24
    "set gfn=Soul\ Lotion:h20
    "set gfn=LT\ Oksana:h18
    "set gfn=Sornette:h36
    "set gfn=KG\ How\ Many\ Times:h48
    "set gfn=Pompiere\ :h24
    "set gfn=BPMono:h24
    "set gfn=Love\ Parade:h24
    "set gfn=Mistress:h36
    "set gfn=KG\ How\ Many\ Times:h36
    "set gfn=RetroRocket:h32
    "set gfn=Calculator:h24
    "set gfn=Give\ A\ Hoot:h24
    "set gfn=KG\ Call\ Me\ Maybe:h24
    "set gfn=Retrievse\ NC:h24
    "set gfn=KG\ Lego\ House:h18
    "set gfn=AylaCSscript:h24
    "set gfn=cumulus:h42
    "set gfn=fresh:h32
    "set gfn=Fecske:h32
    "set gfn=FindYourself:h32
    "set gfn=Unique\ Alpha\ 101:h32
    "set gfn=Aclonica:h24
    "set gfn=Copyright\ Violations:h28
    "set gfn=Flawless:h32
    "set gfn=Juiz\ De\ Fora:h36
    "set gfn=Penna:h48
    "set gfn=MatchBook:h48
    "set gfn=DJB\ COFFEE\ SHOPPE\ BUZZED:h24
    "set gfn=Rolande:h32
    "set gfn=DPStick:h36
    "set gfn=Flamingo:h36
    "set gfn=Brioche\ au\ Potiron:h48
    "set gfn=Glove:h28
    "set gfn=Lilac:h48
    "set gfn=KG\ Beneath\ Your\ Beautiful:h36
    "set gfn=KG\ Beneath\ Your\ Beautiful\ Chunk:h36
    "set gfn=Aspex:h24
    "set gfn=DPBloated:h36
    "set gfn=PineLintGerm:h36
    "set gfn=Giorgino:h24
    "set gfn=LT\ Oksana\ Bold:h18
    "set gfn=LemonCreamPie:h36
    "set gfn=Obti\ Sans:h36
    "set gfn=TF2:h32
    "set gfn=Chinger:h48
    "set gfn=Fundamental\ \ Brigade\ Condensed:h28
    "set gfn=Young\ Dracula\ NFI:h24
    "set gfn=Space\ of\ Time:h32
    "set gfn=HelloHotcakes:h42
    "set gfn=DK\ John\ Brown:h36
    "set gfn=Transmetals\ Condensed:h24
    "set gfn=PWShesAmazing:h42
    "set gfn=Adolphus:h24
    "set gfn=ShadesOfBlue:h36
    "set gfn=Moderna\ Of\ South\ St:h24
    "set gfn=SF\ Chrome\ Fenders:h36
    "set gfn=SF\ Chrome\ Fenders\ Condensed:h36
    "set gfn=High\ Sans\ Serif\ 7:h42
    "set gfn=Crack:h28
    set gfn=Fewt:h26
  elseif WINDOWS()
    "set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
    set gfn=Calculator\ Regular:h16
  endif
endif
if (exists('+colorcolumn'))
  set colorcolumn=80
  highlight ColorColumn ctermbg=9
endif
"--Copy & Paste
noremap <leader>yy "+y
noremap <leader>pp "+gP
"--Split window management
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <leader>W <C-w>s
nnoremap <leader>s :new<CR>
"--Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>
" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry
" change to directory of current file
autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif
" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%
" strip all trailing whitespace in file
nnoremap <leader>W :retab<cr>:%s/\s\+$//<cr>:let @/=''<CR>
" strip TABs
nnoremap <leader>T :retab<cr>
" split open another window
nnoremap <leader>w <C-w>v<C-w>l
set relativenumber
set rnu
"set path=.,/wdrive/games/cocos2d/ptr/cocos,/wdrive/myspace/fusilli/src/main/cpp/fusilli,/wdrive/myspace/fusilli/src/main/cpp/pong,/wdrive/myspace/fusilli/src/main/cpp










