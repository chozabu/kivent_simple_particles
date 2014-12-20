from os import environ, remove
from os.path import dirname, join, isfile
from distutils.core import setup
from distutils.extension import Extension
try:
    from Cython.Build import cythonize
    from Cython.Distutils import build_ext
    have_cython = True
except ImportError:
    have_cython = False


if have_cython:
    particles_files = [
        'particles.pyx'
        ]
    cmdclass = {'build_ext': build_ext}
else:
    particles_files = ['particles.c']
    cmdclass = {}
    
ext = Extension('particles',
    particles_files)

setup(
    name='particles',
    cmdclass=cmdclass,
    ext_modules=[ext])
