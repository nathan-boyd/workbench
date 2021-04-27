" called before SpaceVim core,
function! custom#before() abort
  let g:ascii = [
    \'                                888      888                                 888     ', 
    \'                                888      888                                 888     ', 
    \'                                888      888                                 888     ', 
    \' 888  888  888  .d88b.  888d888 888  888 88888b.   .d88b.  88888b.   .d8888b 88888b. ', 
    \' 888  888  888 d88""88b 888P"   888 .88P 888 "88b d8P  Y8b 888 "88b d88P"    888 "88b', 
    \' 888  888  888 888  888 888     888888K  888  888 88888888 888  888 888      888  888', 
    \' Y88b 888 d88P Y88..88P 888     888 "88b 888 d88P Y8b.     888  888 Y88b.    888  888', 
    \'  "Y8888888P"   "Y88P"  888     888  888 88888P"   "Y8888  888  888  "Y8888P 888  888', 
    \'',
  \]
  let g:startify_custom_header =  'startify#center(startify#fortune#boxed())'
   let g:startify_custom_header_quotes =
      \ startify#fortune#predefined_quotes() +
      \   [
      \     ['Pain of discipline, or pain of regret. Take your pick'], 
      \     ['It always hurts when you go as hard as you can.'],
      \     ['Stick to the basics and when you feel you’ve mastered them it’s time to start all over again, begin anew – again with the basics – this time paying closer attention.'],
      \     ['The secret of getting ahead is getting started. The secret of getting started is breaking your complex overwhelming tasks into small manageable tasks, and then starting on the first one. ~ Mark Twain'],
      \     ['Our bodies are our gardens ~ our wills are our gardeners ~ William Shakespeare'],
      \     ['Computer science education cannot make anybody an expert programmer any more than studying brushes and pigment can make somebody an expert painter. ~ Eric S. Raymond'],
      \     ['Dont worry if it doesn’t work right. If everything did, you’d be out of a job. ~ Mosher’s Law of Software Engineering'],
      \     ['Good design adds value faster than it adds cost. ~ Thomas C. Gale'],
      \     ['Talk is cheap. Show me the code. ~ Linus Torvalds'],
      \     ['I invented the term Object~Oriented, and I can tell you I did not have C++ in mind. ~ Alan Kay'],
      \     ['All human errors are impatience, a premature breaking off of methodical procedure, an apparent fencing~in of what is apparently at issue. ~ Kafka'],
      \     ['Its never too late to become what you might have been'],
      \     ['Hofstadter’s Law: It always takes longer than you expect, even when you take into account Hofstadter’s Law. ~ Douglas Hofstadter'],
      \     ['Success consists of going from failure to failure without loss of enthusiasm. ~ Winston Churchill'],
      \     ['It is neither good nor bad, but thinking makes it so. ~ William Shakespeare'],
      \     ['Light infantry forces typically rely on their ability to operate under restrictive conditions, surprise, violence of action, training, stealth, field craft, and fitness level of the individual soldier to address their reduced lethality. Ironically, forces in a light unit will normally carry heavier individual loads versus other forces; literally they must carry everything they require to fight, survive and win due to lack of vehicles.'],
      \     ['No power in the verse can stop me. ~ River Tam'],
      \     ['Drink the wine and let the world be the world'],
      \     ['I never saw a wild thing feel sorry for itself. A small bird will drop frozen dead from a bough without ever having felt sorry for itself. ~ DH Lawrence'],
      \   ]
endfunction

" called on autocmd VimEnter
function! custom#after() abort

  set ignorecase
  set smartcase
  

  let g:python3_host_prog = '/usr/bin/python3'
  let g:python_host_prog = '/usr/bin/python2'

  set nowrap
  set updatetime=50
  set completeopt+=noselect
  "set termguicolors
  set noswapfile

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
