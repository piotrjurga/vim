if empty(glob('~/.vim/autoload/plug.vim'))
    if has('win32')
        silent !curl -fLo ~/vimfiles/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source ~/_vimrc
    else
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
    endif
endif

call plug#begin('~/.vim/plugged')
Plug 'easymotion/vim-easymotion'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'gaving/vim-textobj-argument'
Plug 'rluba/jai.vim'
Plug 'ludovicchabant/vim-gutentags'
call plug#end()
syntax on
filetype plugin indent on

if has("gui_running")
    colorscheme solarized
    set background=dark
    let g:solarized_italic=0
else
    color desert
endif

set splitright
set splitbelow
set number
set relativenumber
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set scrolloff=10
set nrformats=alpha,hex
set go-=T
set go-=m
set go-=L
set go-=r
"set ignorecase
"set smartcase
set cb=unnamedplus
set hidden

set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

set iskeyword+=ó

" missing emacs bindings for insert mode
inoremap <c-f> <c-o>l
inoremap <c-b> <c-o>h
inoremap <c-a> <c-o>0
inoremap <c-e> <c-o>$
inoremap <c-k> <c-o>D

nnoremap  Q @@
inoremap kj <esc>
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
vnoremap x "_d
nmap <Space>   <Plug>(easymotion-overwin-f)
nnoremap <C-j> i<cr><esc>
vnoremap <leader>c <esc>'<O<C-o>0/*<esc>'>o<C-o>0*/<esc>
onoremap ic :<c-u>execute "normal! ?\\/\\*\rwv/\\*\\/\rb"<cr>
onoremap ac :<c-u>execute "normal! ?\\/\\*\rv/\\*\\/\re"<cr>
nnoremap dsc mq?\/\*<cr>xx/\*\/<cr>xx`q
vnoremap <leader># <esc>'<O#if 0<esc>'>o#endif<esc>
nnoremap da# ?#if<cr>V/#endif<cr>d
nnoremap ds# mq?#if<cr>dd/#endif<cr>dd`q
nnoremap <leader>= ^f=mqkyt=jPv`qr<space>
nnoremap <leader>c ocase X:<esc>==o{<cr>} break;<esc>V?X<cr>j<?X<cr>s
nnoremap <leader>t :!ctags -R<CR>
inoremap <c-t> TODO(piotr): 
imap <tab> <C-p>
imap <S-tab> <C-n>
nmap <leader>e yy:<C-r>"<Bs><CR>
imap <S-space> _
nnoremap <leader>] o{<cr>}<esc>O
nnoremap gb :ls<cr>:b<space>

function! GetCharUnderCursor()
    return matchstr(getline('.'), '\%' . col('.') . 'c.')
endfunction

" select word from identifier under cursor, like this: FooBa|r -> Bar
function! SelectSmallWord()
    if match(expand('<cword>'), "[a-z]") >= 0
        " if the id has any small letters, assume it's camelCase, PascalCase or snake_case
        while match(GetCharUnderCursor(), "[a-z]") == 0 && col('.') > 1
            normal h
        endwhile
        if match(GetCharUnderCursor(), "[^a-zA-Z]") == 0
            normal l
        endif
        normal vl
        while match(GetCharUnderCursor(), "[a-z]") == 0
            normal l
        endwhile
        normal h
    else
        " the id has only capital letters, assume MACRO_CASE
        while match(GetCharUnderCursor(), "[A-Z]") == 0 && col('.') > 1
            normal h
        endwhile
        if match(GetCharUnderCursor(), "[^A-Z]") == 0
            normal l
        endif
        normal vl
        while match(GetCharUnderCursor(), "[A-Z]") == 0
            normal l
        endwhile
        normal h
    endif
endfunction

onoremap if :<c-u>call SelectSmallWord()<cr>

function! AlignAssignmetsInsideV()
    execute "normal '<"
    let EqualsPositions = []
    while line('.') <= line("'>")
        let EqualsPositions += [match(getline("."), "=")]
        normal j
    endwhile
    let MaxEPos = max(EqualsPositions)
    normal '<
    while line('.') <= line("'>")
        normal 0f=
        while virtcol('.') <= MaxEPos
            execute "normal i l"
        endwhile
        normal j
    endwhile
endfunction

vnoremap <leader>= :<c-u>call AlignAssignmetsInsideV()<cr>

nmap <leader>s "tyiw][V[[{:s/\<<c-r>t\>//g<left><left>
nmap gs "tyiw:%s/\<<c-r>t\>//g<left><left>
vmap gs "ty:%s/\V<c-r>t//g<left><left>

nmap <leader>p :w<cr>:!python %<cr>
nmap <leader>l :w<cr>:!pdflatex %<cr>

nnoremap [[ [{
nnoremap ]] ]}

" build bindings
nnoremap <c-m> :w<cr>:silent make<cr>:redraw!<cr>:cc<cr>
nnoremap <c-n> :cn<cr>
nnoremap <c-p> :cp<cr>

nnoremap <c-l> :tabn<cr>
nnoremap <c-h> :tabp<cr>
nnoremap ń /^[^ \t]<cr>
nnoremap H ^
nnoremap L $
