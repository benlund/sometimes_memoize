# -*- encoding: utf-8 -*-

$:.unshift File.expand_path('../lib', __FILE__)
require 'sometimes_memoize'

Gem::Specification.new do |s|
  s.name = 'sometimes_memoize'
  s.version = SometimesMemoize::VERSION

  s.authors = ['Ben Lund']  
  s.description = 'A small library that memoizes method calls or code blocks for the duration of a block call only.'
  s.summary = 'A small library that memoizes method calls or code blocks for the duration of a block call only. Easily turn memoizing on and off. Memoized values are forgotten after it\'s turned off. Annotate existing methods as sometimes memoized. Wrap code blocks and sometimes memoize the result'
  s.email = 'ben@benlund.com'
  s.homepage = 'http://github.com/benlund/sometimes_memoize'

  s.files = ['lib/sometimes_memoize.rb']
end
