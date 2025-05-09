set nocompatible
execute pathogen#infect()

filetype plugin indent on

"just allow backspace to work in insert mode
set backspace=indent,eol,start

syntax enable
syntax on
set guifont=Monaco:h12

colorscheme gruvbox
"colorscheme srcery-drk
"https://github.com/srcery-colors/srcery-colors.github.io

set number

let mapleader=" "

"this speeds things up by keeping things in memory
set hidden
set history=100

filetype indent on
set nowrap
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set autoindent

"this removes whitespaces on save
autocmd BufWritePre * :%s/\s\+$//e

set hlsearch

"cancels search with Escape.
"This caused some annoying problems when it was <silet><Esc> by loading a
"buffer on bottom of page on refocus
nnoremap <Esc><Esc> :nohlsearch<Bar>:echo<CR>

"toggles to previous file
nnoremap <Leader><Leader> :e#<CR>

set showmatch

map <F12> :NERDTreeToggle<CR>

"for Ctrlp.vim  stuff
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

"just mapping to out-of-the-box vim commands
map  <C-n> :tabnew<CR>

" for not holding down j to move down!
"nnoremap jj <nop>

inoremap jj <Esc>

ino " ""<left>
ino ' ''<left>
ino ( ()<left>
ino [ []<left>
ino { {}<left>

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }

"adds save/unsave indicator to status line
function! s:goyo_enter()
  setlocal statusline=%M
  hi StatusLine ctermfg=red guifg=red cterm=NONE gui=NONE
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()

set statusline+=%F

nnoremap <Tab> <c-w>w

let NERDTreeShowHidden=1

nmap <Leader>r :NERDTreeFocus<cr> \| R \| <c-w><c-p>

set nobackup                             " no backup files
set nowritebackup                        " don't backup file while editing
set noswapfile                           " don't create swapfiles for new buffers
set updatecount=0                        " Don't try to write swapfiles after some number of updates
set backupskip=/tmp/*,/private/tmp/*"    " can edit crontab files

"React -- Allow for highlighting in .js files along with .jsx
let g:jsx_ext_required = 0

"changes cursor on insert mode
"let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"let &t_SR = "\<Esc>]50;CursorShape=2\x7"
"let &t_EI = "\<Esc>]50;CursorShape=0\x7"

"Force vue syntax hihglighting on vue file load load
autocmd FileType vue syntax sync fromstart

set modelines=0
set nomodeline

" Set path to search for tags file
set tags=./tags;,tags;

" Enable tags in Vim
set tags+=./tags;

"TODO - CHANGE to only do this in C projects
" regenerate the tags file whenever you save any file in the project, keeping tags always up to date
"autocmd BufWritePost * silent! !ctags -R . &
"
"fmt go files on save
function! GoFmtPreserveCursor()
  " 1) Save current cursor position
  let [save_line, save_col] = [line('.'), col('.')]

  " 2) Run gofmt on the entire buffer
  silent! %!gofmt

  " 3) Restore the cursor position, as long as it's not beyond the last line
  if save_line <= line('$')
    call setpos('.', [0, save_line, save_col, 0])
  endif
endfunction

autocmd BufWritePre *.go call GoFmtPreserveCursor()

function! LLMCopy() abort
   " 1. Gather all files in current directory, recursively.
  let l:files = split(system('find . -type f'), '\n')

  " 2. Prepare a variable to store the aggregated content.
  let l:all_contents = ''

  " 3. Loop through each file path.
  for l:file in l:files
    " Ensure it's readable before proceeding.
    if filereadable(l:file)
      " Use `file --mime-type` to distinguish text from binary.
      let l:mime = system('file --mime-type ' . shellescape(l:file))
      if l:mime =~# 'text/'
        " Read lines from the file.
        let l:file_lines = readfile(l:file)

        " Add a header for clarity
        let l:all_contents .= "======== file: " . l:file . " ========\n"

        " Append each line from the file
        for l:line in l:file_lines
          let l:all_contents .= l:line . "\n"
        endfor

        " Blank line after each file
        let l:all_contents .= "\n"
      endif
    endif
  endfor

  " 4. Copy the entire string to your macOS clipboard via pbcopy.
  call system('pbcopy', l:all_contents)

  echom "All text files have been copied to the clipboard!"
endfunction

command! Lcp call LLMCopy()

Helptags
