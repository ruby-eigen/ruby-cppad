require "cppad/cppad"

CppAD = Cppad
Object.send(:remove_const, "Cppad")

module CppAD
  module ADFunConstructor
    def define_adfunc(varnum)
      x_ = ad_class::create_vec(varnum)
      x = CppAD::__vec_to_pvec__(x_.get_val)
      CppAD::Independent(x_.get_val)

      ex = *yield(x)

      y_ = ad_class::create_vec(ex.size)
      y = CppAD::__vec_to_pvec__(y_.get_val)
      y.each_with_index{|e,i|
        e.__set__(ex[i])
      }

      f = self.new(x_.get_val, y_.get_val)
      f.vars = [x_, x, y_, y] # to avoid these variables being GCed
      return f
    end
  end

  module ADFunCommon
    attr_accessor :vars
  end

  module ADCommon
    def coerce(other)
      c = ADDouble.new(other)
      # To avoid c being GCed.
      @vars ||= []
      @vars << c
      return [c, self]
    end
  end

  class ADDouble
    include ADCommon
  end

  class ADFunDouble
    extend  ADFunConstructor
    include ADFunCommon

    def self.ad_class
      ADDouble
    end
  end

end
