#!/bin/bash

VERSION_kivent_simple_particles=1.0.0
URL_kivent_simple_particles=https://github.com/chozabu/kivent_simple_particles/archive/master.zip
MD5_kivent_simple_particles=
DEPS_kivent_simple_particles=(python cymunk kivy kivent_core)
BUILD_kivent_simple_particles=$BUILD_PATH/kivent_simple_particles/master/
RECIPE_kivent_simple_particles=$RECIPES_PATH/kivent_simple_particles

function prebuild_kivent_simple_particles() {
	true
}

function build_kivent_simple_particles() {
	cd $BUILD_kivent_simple_particles
	echo `pwd`
	echo `ls`
	push_arm

	export LDSHARED="$LIBLINK"
	export PYTHONPATH=$BUILD_kivy/:$PYTHONPATH
	export PYTHONPATH=$BUILD_cymunk/cymunk/python:$PYTHONPATH
	export PYTHONPATH=$BUILD_kivent_core/:$PYTHONPATH
	try find . -iname 'particles' -exec $CYTHON {} \;
	try $BUILD_PATH/python-install/bin/python.host setup.py build_ext -v
	try find build/lib.* -name "*.o" -exec $STRIP {} \;

	export PYTHONPATH=$BUILD_hostpython/Lib/site-packages
	try $BUILD_hostpython/hostpython setup.py install -O2 --root=$BUILD_PATH/python-install --install-lib=lib/python2.7/site-packages

	unset LDSHARED
	pop_arm
}

function postbuild_kivent_simple_particles() {
	true
}
