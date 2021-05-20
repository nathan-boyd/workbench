" called before SpaceVim core,
function! custom#before() abort
  let g:startify_custom_header =  'startify#center(startify#fortune#boxed())'
  set clipboard=unnamedplus
endfunction

" called on autocmd VimEnter
function! custom#after() abort
  let g:python3_host_prog = '/usr/bin/python3'
  let g:python_host_prog = '/usr/bin/python2'

  set wrap
  set ignorecase
  set smartcase
  set updatetime=50
  set completeopt+=noselect
  set noswapfile
  set spell
  set clipboard=unnamedplus

  " be kind when fat fingering common commands
  command! -bang -nargs=* -complete=file E e<bang> <args>
  command! -bang -nargs=* -complete=file W w<bang> <args>
  command! -bang -nargs=* -complete=file Wq wq<bang> <args>
  command! -bang -nargs=* -complete=file WQ wq<bang> <args>
  command! -bang -nargs=* -complete=file Vs vs <args>
  command! -bang Wa wa<bang>
  command! -bang WA wa<bang>
  command! -bang Q q<bang>
  command! -bang QA qa<bang>
  command! -bang Qa qa<bang>

  " call `:exec SynGroup()` to show the ui highlight group under the cursor
  function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
  endfun

  call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })



endfunction
