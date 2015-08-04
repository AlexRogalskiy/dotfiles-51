" Like `wincmd` but also change tmux panes instead of vim windows when needed.
let s:tmux_is_last_pane = 0
au WinEnter * let s:tmux_is_last_pane = 0
function! s:TmuxWinCmd(direction)
  let nr = winnr()
  let tmux_last_pane = (a:direction == 'p' && s:tmux_is_last_pane)
  if !tmux_last_pane
    " try to switch windows within vim
    exec 'wincmd ' . a:direction
  endif
  " Forward the switch panes command to tmux if:
  " a) we're toggling between the last tmux pane;
  " b) we tried switching windows in vim but it didn't have effect.
  if tmux_last_pane || nr == winnr()
    let cmd = 'tmux select-pane -' . tr(a:direction, 'phjkl', 'lLDUR')
    call system(cmd)
    let s:tmux_is_last_pane = 1
    echo cmd
  else
    let s:tmux_is_last_pane = 0
  endif
endfunction

" navigate between split windows/tmux panes
nnoremap <c-j> :call <SID>TmuxWinCmd('j')<cr>
nnoremap <c-k> :call <SID>TmuxWinCmd('k')<cr>
nnoremap <c-h> :call <SID>TmuxWinCmd('h')<cr>
nnoremap <c-l> :call <SID>TmuxWinCmd('l')<cr>
nnoremap <c-\> :call <SID>TmuxWinCmd('p')<cr>
