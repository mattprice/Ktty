require 'rubygems'
require 'bundler'

Bundler.require

# Ktty Plugins
require './gist'
use Gist

require './assets'
use Assets

require './ktty'
run Ktty