function! s:set_sys_path()
  if !has('python3')
    echo 'this vim cannot use python3'
    return v:null
  endif

  python3 << EOF
import sys
import subprocess

status, prefix = subprocess.getstatusoutput('pyenv prefix')

if not(status) and 'pyenv' in prefix:
  version = prefix.split('/')[-1]
  v1 = ''.join(version.split('.')[:2])
  v2 = '.'.join(version.split('.')[:2])
  sys.path = [
    '',
    '{}/lib/python{}.zip'.format(prefix, v1),
    '{}/lib/python{}'.format(prefix, v2),
    '{}/lib/python{}/lib-dynload'.format(prefix, v2),
    '{}/lib/python{}/site-packages'.format(prefix, v2),
    '_vim_path_'
  ]
EOF
endfunction

call s:set_sys_path()
