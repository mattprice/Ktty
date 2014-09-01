require 'rubygems'
require 'bundler'

require 'dotenv'
Dotenv.load

Bundler.require
$: << File.expand_path('../', __FILE__)

require './ktty'
run Ktty::App
