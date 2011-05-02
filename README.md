# Sometimes Memoize

A small Ruby library that memoizes method calls or code blocks for the duration of a block call only.

Useful for:

 * Long-running processes where the result of a method is expensive to compute, and
 * The result is used multiple times within another operation, but
 * You'll want to re-compute the result on a subsequent call, or
 * A result is cheap to compute but changes quickly, and
 * You want to ensure consistency of the value for the duration of another operation

Features:

 * Easily turn memoizing on and off. Memoized values are forgotten after it's turned off.
 * Annotate existing methods as sometimes memoized
 * Wrap code blocks and sometimes memoize the result

## Install

    $ sudo gem install sometimes_memoize

## Summary

    require 'sometimes_memoize'
        
    class Memoizer
      include SometimesMemoize
    
      def incrementor
        @counter ||= 0
        @counter += 1
        @counter
      end
      sometimes_memoize :incrementor
        
    end

    m = Memoizer.new

    assert_equal 1, m.incrementor

    assert_equal 2, m.incrementor

    m.memoizing do
      assert_equal 3, m.incrementor

      assert_equal 3, m.incrementor
    end


For a fuller example see test directory.
