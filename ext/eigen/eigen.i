%module "eigen"

%include "ruby-eigen/ext/eigen/rb_error_handle.i"
%include "ruby-eigen/ext/eigen/dense/common_methods.i"

%import "../cppad/cppad.i"
%import "ruby-eigen/ext/eigen/eigen.i"


%{

#include <stdexcept>
#include <cppad/example/cppad_eigen.hpp>

  namespace RubyCppAD {
    using namespace CppAD;
    typedef Eigen::Matrix< AD<double> , Eigen::Dynamic, Eigen::Dynamic > MatrixADDouble;
    typedef Eigen::Matrix< AD<double> , Eigen::Dynamic, 1 > VectorADDouble;
  };

%}


namespace RubyCppAD {
  class VectorADDouble {
  public:
    VectorADDouble(size_t);
    ~VectorADDouble();
  };

  class MatrixADDouble {
  public:
    MatrixADDouble(size_t, size_t);
    ~MatrixADDouble();

  };
};
