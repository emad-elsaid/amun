$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'amun'
require "simplecov"

SimpleCov.start
require 'minitest/autorun'
