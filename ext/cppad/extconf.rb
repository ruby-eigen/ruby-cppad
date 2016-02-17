require 'mkmf'
have_library("c++") or have_library("stdc++")

cppad_path = File.join(File.dirname(File.expand_path(__FILE__)), "cppad/")
$CXXFLAGS = ($CXXFLAGS || "") + " -O2 -Wall -I #{cppad_path} "
create_makefile('cppad/cppad')
