" called before SpaceVim core,
function! custom#before() abort
endfunction

" called on autocmd VimEnter
function! custom#after() abort

  let g:python3_host_prog = '/usr/bin/python3'
  let g:python_host_prog = '/usr/bin/python2'
""  let g:deoplete#enable_at_startup = 1
""
""  runtime! plugin/rplugin.vim
""  silent! UpdateRemotePlugins
""
""  if exists(':UpdateRemotePlugins') && !filereadable('.-rplugin~')
""    silent UpdateRemotePlugins
""  endif

  set nowrap
  set updatetime=50
  set completeopt+=noselect
  "set termguicolors
  set noswapfile

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

  " call `:exec SynGroup()` to show the highlight group under the cursor
  function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
  endfun

  call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

 
endfunction
