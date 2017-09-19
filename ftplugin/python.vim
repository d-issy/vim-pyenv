function! s:strip(str)
  return substitute(a:str, '\n', '', '')
endfunction


function! s:has_pyenv()
  let l:pyenv = system("which pyenv")
  if v:shell_error == 0
    return v:true
  else
    return v:false
  endif
endfunction


function! s:get_python_version()
  if !has('python3')
    return v:null
  endif
  let l:python = s:strip(system("python -V"))
  let l:python_version = split(l:python, " ")[1]
  return l:python_version
endfunction

function! s:trim_version(option)
  let l:v  = split(s:get_python_version(), '\.')
  if a:option == 1
    return join(l:v[0:1], '')
  elseif a:option == 2
    return join(l:v[0:1], '.')
  endif
endfunction

function! s:set_sys_path()
  if !s:has_pyenv()
    return
  endif

  let l:p = s:strip(system('pyenv prefix'))
  let l:v1 = s:trim_version(1)
  let l:v2 = s:trim_version(2)

  python3 << EOF
import os
import sys
from pprint import pprint

sys.path = [
    '',
    vim.eval('l:p') + '/lib/python' + vim.eval('l:v1') +'.zip',
    vim.eval('l:p') + '/lib/python' + vim.eval('l:v2'),
    vim.eval('l:p') + '/lib/python' + vim.eval('l:v2') + '/lib-dynload',
    vim.eval('l:p') + '/lib/python' + vim.eval('l:v2') + '/site-packages',
]
EOF
endfunction


call s:set_sys_path()
