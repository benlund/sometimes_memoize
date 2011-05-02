require 'test/unit'

unless ARGV.include?('gem')
  $:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
end
require 'sometimes_memoize'

class Memoizer
  include SometimesMemoize

  def incrementor
    @counter ||= 0
    @counter += 1
    @counter
  end
  sometimes_memoize :incrementor

  def concatenator
    @string ||= ''
    @string << 'x'
    @string
  end
  sometimes_memoize :concatenator

  def spreader
    outer = sometimes_memoizing(:outer) do
      @outer ||= ''
      @outer << '-'
      @outer
    end
    "#{outer}+#{outer}"
  end

  def consistently
    self.memoizing do
      self.spreader + self.incrementor.to_s + self.concatenator + self.incrementor.to_s + self.concatenator + self.spreader
    end
  end

end


class SometimesMemoizeTest < Test::Unit::TestCase

  def test_sometimes_memoize

    m = Memoizer.new

    assert_equal 1, m.incrementor
    assert_equal 'x', m.concatenator
    assert_equal '-+-', m.spreader

    assert_equal 2, m.incrementor
    assert_equal 'xx', m.concatenator
    assert_equal '--+--', m.spreader

    m.memoizing do
      assert_equal 3, m.incrementor
      assert_equal 'xxx', m.concatenator
      assert_equal '--+--', m.spreader
      assert_equal 3, m.incrementor
      assert_equal 'xxx', m.concatenator
      assert_equal '--+--', m.spreader
    end

    assert_equal 4, m.incrementor
    assert_equal 'xxxx', m.concatenator
    assert_equal '-+-', m.spreader

    assert_equal '-+-5xxxxx5xxxxx-+-', m.consistently
    assert_equal '-+-6xxxxxx6xxxxxx-+-', m.consistently

  end

end
