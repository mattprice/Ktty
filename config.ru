require 'rubygems'
require 'bundler'

Bundler.require

# Ktty Plugins
require './gist'
use Gist

require './pastebin'
use Pastebin

# Assets Plugin
require './assets'
use Assets

# Ktty
require './ktty'
run Ktty