require 'rubygems'
require 'bundler'

require './ktty'
require './assets'

Bundler.require
use Assets
run Ktty