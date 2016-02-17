require "test/unit"
require "cppad"

class TestCppAD < Test::Unit::TestCase
  include CppAD

  def test_forward
    x_ = ADDouble::create_vec(2)
    x = __vec_to_pvec__(x_.get_val)
    Independent(x_.get_val)
    y_ = ADDouble::create_vec(1)
    y = __vec_to_pvec__(y_.get_val)
    y[0].__set__(x[0]**2 + x[1]**2)
    f = ADFunDouble.new(x_.get_val, y_.get_val)
    assert_equal([10], f.forward(0, [1,3]))
  end

  def test_ad_const
    x_ = ADDouble::create_vec(2)
    x = __vec_to_pvec__(x_.get_val)
    Independent(x_.get_val)
    y_ = ADDouble::create_vec(1)
    y = __vec_to_pvec__(y_.get_val)
    c = ADDouble.new(2)
    y[0].__set__(x[0]**2 + c*x[1]**2)
    f = ADFunDouble.new(x_.get_val, y_.get_val)
    assert_equal([19], f.forward(0, [1,3]))
  end

  def test_coerce
    x_ = ADDouble::create_vec(2)
    x = __vec_to_pvec__(x_.get_val)
    Independent(x_.get_val)
    y_ = ADDouble::create_vec(1)
    y = __vec_to_pvec__(y_.get_val)
    c = ADDouble.new(2)
    y[0].__set__(x[0]**2 + 2**x[1])
    f = ADFunDouble.new(x_.get_val, y_.get_val)
    assert_equal([9], f.forward(0, [1,3]))
  end

  def test_define_adfunc
    f = ADFunDouble::define_adfunc(2) do |x|
      [x[0]**2 + 2**x[1], x[0]**2 + x[1]**2]
    end
    assert_equal([9, 10], f.forward(0, [1,3]))
  end

end
