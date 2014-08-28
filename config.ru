require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)

require './ktty'
run Ktty::App