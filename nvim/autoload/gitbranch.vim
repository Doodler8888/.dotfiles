let s:save_cpo = &cpo
set cpo&vim

" Helper function to get the correct path for the current buffer,
" handling oil.nvim buffers specifically.
function! s:get_path() abort
  if &filetype ==# 'oil'
    try
      let oil_dir = luaeval("require('oil').get_current_dir()")
      if oil_dir isnot v:null && !empty(oil_dir)
        return oil_dir
      endif
    catch
      " In case of error, fall back gracefully.
    endtry
  endif
  return expand('%:p:h')
endfunction

function! gitbranch#name() abort
  " Use the helper function to get the correct path.
  let l:path = s:get_path()
  " Check if the cached path is outdated or doesn't exist.
  if get(b:, 'gitbranch_pwd', '') !=# l:path || !has_key(b:, 'gitbranch_path')
    " If so, re-detect the git branch for the current path.
    call gitbranch#detect(l:path)
  endif
  if has_key(b:, 'gitbranch_path') && filereadable(b:gitbranch_path)
    let branch = get(readfile(b:gitbranch_path), 0, '')
    if branch =~# '^ref: '
      return substitute(branch, '^ref: \%(refs/\%(heads/\|remotes/\|tags/\)\=\)\=', '', '')
    elseif branch =~# '^\x\{20\}'
      return branch[:6]
    endif
  endif
  return ''
endfunction

function! gitbranch#dir(path) abort
  let path = a:path
  let prev = ''
  let git_modules = path =~# '/\.git/modules/'
  while path !=# prev
    let dir = path . '/.git'
    let type = getftype(dir)
    if type ==# 'dir' && isdirectory(dir.'/objects') && isdirectory(dir.'/refs') && getfsize(dir.'/HEAD') > 10
      return dir
    elseif type ==# 'file'
      let reldir = get(readfile(dir), 0, '')
      if reldir =~# '^gitdir: '
        return simplify(path . '/' . reldir[8:])
      endif
    elseif git_modules && isdirectory(path.'/objects') && isdirectory(path.'/refs') && getfsize(path.'/HEAD') > 10
      return path
    endif
    let prev = path
    let path = fnamemodify(path, ':h')
  endwhile
  return ''
endfunction

function! gitbranch#detect(path) abort
  unlet! b:gitbranch_path
  " Use the provided path to set the buffer-local 'pwd'.
  let b:gitbranch_pwd = a:path
  let dir = gitbranch#dir(a:path)
  if dir !=# ''
    let path = dir . '/HEAD'
    if filereadable(path)
      let b:gitbranch_path = path
    endif
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

if exists('g:loaded_gitbranch') || v:version < 700
  finish
endif
let g:loaded_gitbranch = 1

let s:save_cpo = &cpo
set cpo&vim

augroup GitBranch
  autocmd!
  autocmd BufNewFile,BufReadPost * call gitbranch#detect(expand('<amatch>:p:h'))
  " Use the helper function to get the correct path on BufEnter.
  autocmd BufEnter * call gitbranch#detect(s:get_path())
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
