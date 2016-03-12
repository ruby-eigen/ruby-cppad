%module "eigen"

%include "ruby-eigen/ext/eigen/rb_error_handle.i"
%include "ruby-eigen/ext/eigen/dense/common_methods.i"

%import "../cppad/cppad.i"
%import "ruby-eigen/ext/eigen/eigen.i"


%{
#define EIGEN_MATRIXBASE_PLUGIN <cppad/example/eigen_plugin.hpp>
#include <Eigen/Core>
#include <Eigen/LU>
#include <Eigen/Eigenvalues>
#include <Eigen/QR>
#include <Eigen/SVD>
#include <Eigen/Cholesky>
#include <Eigen/SparseCore>
#include <Eigen/SparseCholesky>
#include <Eigen/SparseLU>
#include <Eigen/SparseQR>
#include <Eigen/IterativeLinearSolvers>
#include <Eigen/Sparse>
%}

%inline %{
namespace Eigen {};
namespace RubyEigen {
  using namespace Eigen;
};
%}

%{

#include <stdexcept>
#include <cppad/example/cppad_eigen.hpp>
#include "ruby-eigen/ext/eigen/rubyeigen_algo.h"
#include "ruby-eigen/ext/eigen/rubyeigen_base.h"
#include "../cppad/rubycppad.h"

  namespace RubyCppADEigen {
    using namespace CppAD;
    typedef Eigen::Matrix< RubyCppAD::AD<double> , Eigen::Dynamic, Eigen::Dynamic > MatrixADDouble;
    typedef Eigen::Matrix< RubyCppAD::AD<double> , Eigen::Dynamic, 1 > VectorADDouble;
  };

%}


namespace RubyCppADEigen {
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
  void Independent( VectorADDouble& );

};
