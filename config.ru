require 'rubygems'
require 'bundler'

Bundler.require

# Ktty Plugins
require './gist'
use Gist

# Assets Plugin
require './assets'
use Assets

# Ktty
require './ktty'
run Ktty