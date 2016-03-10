%module "eigen"

%include "ruby-eigen/ext/eigen/rb_error_handle.i"

%import "../cppad/cppad.i"
%import "ruby-eigen/ext/eigen/eigen.i"


%{

#include <stdexcept>
#include <cppad/example/cppad_eigen.hpp>

  namespace RubyCppAD {
    using namespace CppAD;
    typedef Eigen::Matrix< AD<double> , Eigen::Dynamic, Eigen::Dynamic > MatrixADDouble;
  };

%}


namespace RubyCppAD {
  class MatrixADDouble {
  public:
    MatrixADDouble(size_t, size_t);
    ~MatrixADDouble();
  };
};
