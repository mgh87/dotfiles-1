" =============================================================================
"                               General settings
" =============================================================================

set nocompatible        " iMproved.
set hidden              " Allow for putting dirty buffers in background.
set ignorecase          " Case-insensitive search
set smartcase           " Override ignorecase when searching uppercase.
set modeline            " Enables modelines.
set wildmode=longest,list:full " How to complete <Tab> matches.
set virtualedit=block   " Support moving in empty space in block mode.
set clipboard=unnamed   " Propagate yank/paste to system clipboard

" Low priority for these files in tab-completion.
set suffixes+=.aux,.bbl,.blg,.dvi,.log,.pdf,.fdb_latexmk     " LaTeX
set suffixes+=.info,.out,.o,.lo

set viminfo='20,\"500

" No header when printing.
set printoptions+=header:0

scriptencoding utf-8

if has("spell")
  set spelllang=en,de,fr
  set spellfile=~/.vim/spell/spellfile.add
endif

" =============================================================================
"                                   Styling
" =============================================================================

set hlsearch            " Highlight search results.
set showbreak=…         " Highlight non-wrapped lines.
set showcmd             " Display incomplete command in bottom right corner.

if has('gui_running')
    set columns=80
    set lines=25
    set guioptions-=T   " Remove the toolbar.
    set guifont=MesloLGM\ Nerd\ Font:h12

    " Disable MacVim-specific Cmd/Alt key mappings.
    if has("gui_macvim")
      let macvim_skip_cmd_opt_movement = 1
    endif
endif

" Folding
if version >= 600
    set foldenable
    set foldmethod=marker
endif

" =============================================================================
"                                  Formatting
" =============================================================================

set formatoptions=tcrqn " See :h 'fo-table for a detailed explanation.
set nojoinspaces        " Don't insert two spaces when joining after [.?!].
set copyindent          " Copy the structure of existing indentation
set expandtab           " Expand tabs to spaces.
"set tabstop=4           " number of spaces for a <Tab>.
set softtabstop=4       " Number of spaces that a <Tab> counts for.
set shiftwidth=4        " Tab indention
"set textwidth=79        " Text width

" Indentation Tweaks.
" l1  = align with case label isntead of steatement after it in the same line.
" N-s = Do not indent namespaces.
" t0  = do not indent a function's return type declaration.
" (0  = line up with next non-white character after unclosed parentheses...
" W2  = ...but not if the last character in the line is an open parenthesis.
set cinoptions=l1,N-s,t0,(0,W2

" =============================================================================
"                                 Key Bindings
" =============================================================================

let mapleader = ' '

" vv to generate new vertical split
nnoremap <silent> vv <C-w>v
nnoremap <silent> v2 :set columns=161<CR><C-w>v
nnoremap <silent> v3 :set columns=242<CR><C-w>v<C-w>v

" Clear last search highlighting
nnoremap <CR> :noh<CR><CR>

" Toggle list mode (display unprintable characters).
nnoremap <F11> :set list!<CR>

" Toggle paste mode.
set pastetoggle=<F12>

" Helper function to preserve history and cursor position.
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business.
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" Remove trailing whitespace.
nmap <Leader>$ :call Preserve("%s/\\s\\+$//e")<CR>

" Indent entire file.
nmap <Leader>= :call Preserve("normal gg=G")<CR>

" Highlight text last pasted.
nnoremap <expr> <Leader>p '`[' . strpart(getregtype(), 0, 1) . '`]'

" Reverse letters in a word, e.g, "foo" -> "oof".
vnoremap <silent> <Leader>r :<C-U>let old_reg_a=@a<CR>
 \:let old_reg=@"<CR>
 \gv"ay
 \:let @a=substitute(@a, '.\(.*\)\@=',
 \ '\=@a[strlen(submatch(1))]', 'g')<CR>
 \gvc<C-R>a<Esc>
 \:let @a=old_reg_a<CR>
 \:let @"=old_reg<CR>

" =============================================================================
"                                    Plugins
" =============================================================================

" Install Plug if not present.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !mkdir -p ~/.vim/autoload
  silent !curl -fLo ~/.vim/autoload/plug.vim
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dhruvasagar/vim-zoom'
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf' | Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'mephux/bro.vim'
Plug 'mhinz/vim-signify'
Plug 'rhysd/vim-clang-format'
Plug 'rstacruz/sparkup'
Plug 'ryanoasis/vim-devicons'
Plug 'mgh87/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'jalvesaq/Nvim-R'
call plug#end()

" let g:nord_comment_brightness = 10
let g:nord_cursor_line_number_background = 1

colorscheme nord

" -- fzf ---------------------------------------------------------------------

" Mapping selecting mappings.
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion.
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using autoload functions.
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})


"" -- Tmuxline ----------------------------------------------------------------
"
"let g:tmuxline_theme = 'lightline'
"" We use :TmuxlineSnapshot to generate .tmux/tmuxline-(light|dark).conf.
"" Thereafter, we need to do a bit of patching to improve the integration of
"" tmxu-mem-cpu-load. (https://github.com/edkolev/tmuxline.vim/issues/78)
"let g:tmuxline_preset = {
"  \'a'       : '#S',
"  \'x'       : ' %Y-%m-%d  %H:%M',
"  \'y'       : '#(tmux-mem-cpu-load -q -g 5 -m 2 -i 2)',
"  \'z'       : ' #h',
"  \'win'     : ['#I', '#W'],
"  \'cwin'    : ['#I', '#W'],
"  \'options' : {'status-justify' : 'left'}}
"
"" -- Tmux Navigator ----------------------------------------------------------

let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>

" -- Vimux -------------------------------------------------------------------

" Combine VimuxZoomRunner and VimuxInspectRunner in one function.
function! VimuxZoomInspectRunner()
  if exists("g:VimuxRunnerIndex")
    call _VimuxTmux("select-"._VimuxRunnerType()." -t ".g:VimuxRunnerIndex)
    call _VimuxTmux("resize-pane -Z -t ".g:VimuxRunnerIndex)
    call _VimuxTmux("copy-mode")
  endif
endfunction

map <Leader>vc :VimuxPromptCommand<CR>
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vo :call VimuxOpenRunner()<CR>
map <Leader>vp :call VimuxSendKeys("C-p Enter")<CR>
map <Leader>vc :VimuxInterruptRunner<CR>
map <Leader>vi :VimuxInspectRunner<CR>
map <Leader>vq :VimuxCloseRunner<CR>
map <Leader>vz :VimuxZoomRunner<CR>
map <Leader>vm :VimuxRunCommand("make")<CR>
map <Leader>vn :VimuxRunCommand("ninja")<CR>
map <Leader>v<Space> :call VimuxZoomInspectRunner()<CR>

" -- vim-dispatch ------------------------------------------------------------

" -- Nvim-R ------------------------------------------------------------------

" Make sure we can communicate with the plugin.
let R_in_buffer = 0
let R_applescript = 0
let R_tmux_split = 1
let R_min_editor_width = 42 "trigger vertical split

" Do not replace '_' with '<-'.
let R_assign = 0

" Use existing tmux.conf.
let R_notmuxconf = 1

" -- Clang Format ------------------------------------------------------------

map <Leader>f :ClangFormat<CR>

" =============================================================================
"                                Filetype Stuff
" =============================================================================

" Respect (Br|D)oxygen comments.
augroup filetype_tex
  autocmd!
  if has("spell")
    autocmd Filetype tex  set spell
  endif
  autocmd Filetype tex set iskeyword+=:
augroup END

augroup filetype_cpp
  autocmd!
  " Doxygen
  autocmd FileType c,cpp set comments-=://
  autocmd FileType c,cpp set comments+=:///
  autocmd FileType c,cpp set comments+=://
augroup END

" Bro
augroup filetype_bro
  autocmd!
  autocmd BufRead,BufNewFile *.bro set filetype=bro
  autocmd BufRead,BufNewFile *.pac2 set filetype=ruby
  autocmd FileType bro set cino='>1s,f1s,{1s'
  autocmd FileType bro set comments-=:#
  autocmd FileType bro set comments+=:##
  autocmd FileType bro set comments+=:#
augroup END

" Emails
augroup filetype_mail
  autocmd!
  if has("spell")
    autocmd Filetype mail set spell
  endif
  autocmd BufRead,BufNewFile *.mail set filetype=mail
  autocmd FileType mail setlocal sw=4 ts=4 tw=72
  autocmd FileType mail setlocal formatoptions+=w " Use f=f encoding.
  autocmd FileType mail highlight TrailingWhitespace cterm=underline ctermfg=red
  autocmd FileType mail match TrailingWhitespace /\s\+$/
augroup END

" R
augroup filetype_r
  autocmd!
  autocmd BufNewFile,BufRead *.[rRsS] set ft=r
  autocmd BufRead *.R{out,history} set ft=r
augroup END

" Transparent editing of gpg encrypted files.
augroup filetype_gpg
  autocmd!
  " First make sure nothing is written to ~/.viminfo while editing
  " an encrypted file.
  autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
  " We don't want a swap file, as it writes unencrypted data to disk
  autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
  " Switch to binary mode to read the encrypted file
  autocmd BufReadPre,FileReadPre      *.gpg set bin
  autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt 2> /dev/null
  " Switch to normal mode for editing
  autocmd BufReadPost,FileReadPost    *.gpg set nobin
  autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

  " Convert all text to encrypted text before writing
  autocmd BufWritePre,FileWritePre    *.gpg '[,']!gpg --default-recipient-self -ae 2>/dev/null
  " Undo the encryption so we are back in the normal text, directly
  " after the file has been written.
  autocmd BufWritePost,FileWritePost  *.gpg u
augroup END

