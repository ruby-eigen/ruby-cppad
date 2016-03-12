namespace CppAD {};
namespace RubyCppAD {
  using namespace CppAD;
  typedef RubyCppAD::AD<double> ADDouble;
  typedef RubyCppAD::ADFun<double> ADFunDouble;

  /*
     Calling %template for std::vector<ADDouble> causes an error.
     So we use a wrapper class for std::vector<ADDouble>.
   */
  template<class T>
  class VectorWrapper {
  public:
    VectorWrapper(std::vector<T>* p) : v_(p) {}
    ~VectorWrapper() { delete v_; }
    std::vector<T>* get_val() {
      return v_;
    }
  private:
    std::vector<T>* v_;
  };

  typedef RubyCppAD::VectorWrapper< RubyCppAD::AD<double> > VectorWrapperDouble;
};
