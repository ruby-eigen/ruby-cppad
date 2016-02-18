%module cppad

%{
#include <cppad/cppad.hpp>
namespace RubyCppAD {
  using namespace CppAD;
};
%}

%include std_vector.i
%template(StdVectorADDoublePtr) ::std::vector<RubyCppAD::AD<double>*>;

%{
namespace RubyCppAD {
  using namespace CppAD;

  template<class T>
  std::vector<T*> __vec_to_pvec__(std::vector<T>& v){
    std::vector<T*> ret(v.size());
    for(int i = 0; i < v.size(); i++){
      ret[i] = &(v[i]);
    }
    return ret;
  }


  VALUE cppad_rb_proc_call(VALUE args[]){
    return rb_proc_call(args[0], args[1]);
  }

  void fg_eval(std::vector< AD<double>* >& fg, std::vector< AD<double>* >& x){
    VALUE prc = rb_block_proc();
    VALUE ret;
    VALUE args[2];
    args[0] = prc;
    args[1] = swig::from< std::vector<AD<double>* > >(x);
    ret = rb_rescue2(RUBY_METHOD_FUNC(cppad_rb_proc_call), (VALUE) args,
                     0, 0, rb_eStandardError);
    std::vector< AD<double>* > *z;
    if( !NIL_P(ret) && SWIG_IsOK(swig::asptr(ret, &z)) ){
      for(int i = 0; i < fg.size(); i++){
        fg[i] = (*z)[i];
      }
    }else{
      SWIG_Error(SWIG_RuntimeError, "Array of double expected");
    }
  }
};

%}


%inline %{

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

%}


namespace RubyCppAD {

template<class T>
class AD{
public:
  AD();
  AD(const T&);
  ~AD();

  %newobject create_vec;
  %extend{
    static RubyCppAD::VectorWrapper< RubyCppAD::AD<T> >& create_vec(std::size_t n){
      std::vector< RubyCppAD::AD<T> > *p = new std::vector< RubyCppAD::AD<T> >(n);
      RubyCppAD::VectorWrapper< RubyCppAD::AD<T> > *v =
        new RubyCppAD::VectorWrapper< RubyCppAD::AD<T> >(p);
      return *v;
    }

    void __set__(const RubyCppAD::AD<T>& x){
      (*$self) = x;
    }

    RubyCppAD::AD<T> __neg__(){
      return -(*$self);
    }

    RubyCppAD::AD<T> __add__(const RubyCppAD::AD<T>& x){
      return (*$self) + x;
    }

    RubyCppAD::AD<T> __add__(const T& x){
      return (*$self) + x;
    }

    RubyCppAD::AD<T> __sub__(const RubyCppAD::AD<T>& x){
      return (*$self) - x;
    }

    RubyCppAD::AD<T> __sub__(const T& x){
      return (*$self) - x;
    }

    RubyCppAD::AD<T> __mul__(const RubyCppAD::AD<T>& x){
      return (*$self) * x;
    }

    RubyCppAD::AD<T> __mul__(const T& x){
      return (*$self) * x;
    }

    RubyCppAD::AD<T> __div__(const RubyCppAD::AD<T>& x){
      return (*$self) / x;
    }

    RubyCppAD::AD<T> __div__(const T& x){
      return (*$self) / x;
    }

    RubyCppAD::AD<T> __pow__(const RubyCppAD::AD<T>& x){
      return pow((*$self), x);
    }

    RubyCppAD::AD<T> __pow__(const T& x){
      return pow((*$self), x);
    }

  }

};

%template(ADDouble) AD<double>;
  // %template(StdVectorADDoublePtr) ::std::vector<RubyCppAD::ADDouble*>;
%template(StdVectorDouble) ::std::vector<double>;
%template(VectorWrapperDouble) RubyCppAD::VectorWrapper< RubyCppAD::AD<double> >;

std::vector<RubyCppAD::ADDouble*> __vec_to_pvec__(std::vector<RubyCppAD::ADDouble>& v);

template<class T>
class ADFun{
public:
  ADFun(const std::vector< RubyCppAD::AD<T> >&,
        const std::vector< RubyCppAD::AD<T> >&);

%rename(domain_dim) Domain;
  std::size_t Domain();
%rename(range_dim) Range;
  std::size_t Range();

%rename(forward) Forward;
  std::vector<T> Forward(const int, const std::vector<T>&);
%rename(jacobian) Jacobian;
  std::vector<T> Jacobian(const std::vector<T>&);
%rename(hessian) Hessian;
  std::vector<T> Hessian(const std::vector<T>&, std::size_t);

  std::size_t compare_change_number();
  std::size_t compare_change_op_index();

};

%template(ADFunDouble)  ADFun<double>;

void Independent( std::vector<RubyCppAD::ADDouble>& );


RubyCppAD::ADDouble sin(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble cos(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble tan(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble exp(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble expm1(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble log(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble log10(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble log1p(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble sinh(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble cosh(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble tanh(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble asin(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble acos(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble atan(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble asinh(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble acosh(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble atanh(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble atan2(const RubyCppAD::ADDouble&, const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble erf(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble sqrt(const RubyCppAD::ADDouble&);

RubyCppAD::ADDouble sign(const RubyCppAD::ADDouble&);
RubyCppAD::ADDouble abs(const RubyCppAD::ADDouble&);

double sin(const double&);
double cos(const double&);
double tan(const double&);
double exp(const double&);
double expm1(const double&);
double log(const double&);
double log10(const double&);
double log1p(const double&);
double sinh(const double&);
double cosh(const double&);
double tanh(const double&);
double asin(const double&);
double acos(const double&);
double atan(const double&);
double asinh(const double&);
double acosh(const double&);
double atanh(const double&);
double atan2(const double&, const double&);
double erf(const double&);
double sqrt(const double&);
double sign(const double&);
double abs(const double&);

RubyCppAD::ADDouble CondExpEq(const RubyCppAD::ADDouble&, const RubyCppAD::ADDouble&,
                              const RubyCppAD::ADDouble&, const RubyCppAD::ADDouble&);
  // %rename(cond_gt) CondExpGt;
RubyCppAD::ADDouble CondExpGt(const RubyCppAD::ADDouble&, const RubyCppAD::ADDouble&,
                              const RubyCppAD::ADDouble&, const RubyCppAD::ADDouble&);
  // %rename(cond_gt) CondExpGe;
RubyCppAD::ADDouble CondExpGe(const RubyCppAD::ADDouble&, const RubyCppAD::ADDouble&,
                              const RubyCppAD::ADDouble&, const RubyCppAD::ADDouble&);
  // %rename(cond_lt) CondExpLt;
RubyCppAD::ADDouble CondExpLt(const RubyCppAD::ADDouble&, const RubyCppAD::ADDouble&,
                              const RubyCppAD::ADDouble&, const RubyCppAD::ADDouble&);
  // %rename(cond_le) CondExpLe;
RubyCppAD::ADDouble CondExpLe(const RubyCppAD::ADDouble&, const RubyCppAD::ADDouble&,
                              const RubyCppAD::ADDouble&, const RubyCppAD::ADDouble&);

};

