call plug#begin('~/.nvim/config/plugged')
Plug 'bronson/vim-trailing-whitespace'
Plug 'danilo-augusto/vim-afterglow'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mattn/emmet-vim'
Plug 'mikepjb/vim-chruby'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-test/vim-test'
Plug 'wakatime/vim-wakatime'
call plug#end()

" -----------------------
"  Global configs

" space is the leader key
let mapleader = " "

set number relativenumber
set tabstop=2
set shiftwidth=2
set expandtab
set clipboard+=unnamedplus

" Run `gem install neovim` in order for the host script to work
let g:ruby_host_prog = $GEM_HOME . '/bin/neovim-ruby-host'

" vim-test run strategy https://github.com/vim-test/vim-test#strategies
let test#strategy = "neovim"

colorscheme afterglow
let g:afterglow_blackout=1

let g:user_emmet_install_global = 0
let g:user_emmet_leader_key='<C-e>'
autocmd FileType html,css,eruby EmmetInstall

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

function DeleteEndLines()
  let current_pos = getpos(".") " save current position
  silent! %s#\($\n\s*\)\+\%$##
  call setpos('.', current_pos) " move cursor back to the saved positon
endfunction
autocmd BufWritePre * call DeleteEndLines()
autocmd BufWritePre * FixWhitespace

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | wincmd p
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

" -----------------------
" Mappings

" Basic
map <leader><leader>s :w<CR>
map <leader><leader>q :q<CR>

" Maintain visual block selection after indentation
vnoremap < <gv
vnoremap > >gv

" Indent with single < > key press
nnoremap > >>
nnoremap < <<

" Comment lines toggle
map <leader>c gc

" Move lines with CTRL + Arrow keys
nnoremap <C-Down> :m .+1<CR>==
nnoremap <C-Up> :m .-2<CR>==
inoremap <C-Down> <Esc>:m .+1<CR>==gi
inoremap <C-Up> <Esc>:m .-2<CR>==gi
vnoremap <C-Down> :m '>+1<CR>gv=gv
vnoremap <C-Up> :m '<-2<CR>gv=gv

" Plug
" pi -> plug install
" pu -> plug update
map <leader>pi :PlugInstall<CR>
map <leader>pu :PlugUpdate<CR>

" NERDTree
" f -> file
" ft -> file toggle
" fn -> file new
" fm -> file move
map <leader>ft :NERDTreeToggle<CR>
map <leader>fn :NERDTreeFocus<CR>ma " New directory/file
map <leader>fm :NERDTreeFocus<CR>mm " Rename/move directory/file

" Fuzzy finder
" s -> search
" sf -> search files
" so -> search open files
" sp -> search in project
" sc -> search commits for current file
map <leader>sf :Files<CR>
map <leader>so :Buffers<CR>
map <leader>sp :Ag<CR>
map <leader>sc :BCommits<CR>

" Git
" g -> git
" gs -> git status
" gb -> git blame
map <leader>gs :GFiles?<CR>
map <leader>gb :Git blame<CR>

" Tests
" tn -> test nearest
" tf -> test file
" ts -> test suite
" tl -> test last
" tg -> test go to last test file ran
nmap <leader>tn :TestNearest<CR>
nmap <leader>tf :TestFile<CR>
nmap <leader>ts :TestSuite<CR>
nmap <leader>tl :TestLast<CR>
nmap <leader>tg :TestVisit<CR>

" Alternate files
" at -> alternate test file (only for ruby files and rspec tests) (uses custom
" rplugin)
nmap <leader>at :CreateSpecFile<CR>

" Window management
" Alt + direction -> Move to the window in that direction
" wb -> new window at the bottom
" wr -> new window at the right
nmap <A-Left> <C-w>h
nmap <A-h> <C-w>h
nmap <A-Right> <C-w>l
nmap <A-l> <C-w>l
nmap <A-Up> <C-w>k
nmap <A-k> <C-w>k
nmap <A-Down> <C-w>j
nmap <A-j> <C-w>j
nmap <leader>wb <C-w>s
nmap <leader>wr <C-w>v
