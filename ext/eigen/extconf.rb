require 'mkmf'
have_library("c++") or have_library("stdc++")

cppad_path = File.join(File.dirname(File.expand_path(__FILE__)), "../cppad/cppad/")
ruby_eigen_path = File.join(File.dirname(File.expand_path(__FILE__)), "ruby-eigen/ext/eigen/eigen3")
$CXXFLAGS = ($CXXFLAGS || "") + " -O2 -Wall -I #{cppad_path} -I #{ruby_eigen_path} "
create_makefile('cppad/eigen')
