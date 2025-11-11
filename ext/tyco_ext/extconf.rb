require 'mkmf'

root = File.expand_path('../../..', __dir__)
incdir = File.join(root, 'tyco-c', 'include')
libdir = File.join(root, 'tyco-c', 'build')

dir_config('tyco_c', incdir, libdir)

abort 'libtyco_c not found. Please build tyco-c first.' unless have_library('tyco_c')

create_makefile('tyco_ext/tyco_ext')
