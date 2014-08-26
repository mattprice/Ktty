require 'rubygems'
require 'bundler'

Bundler.require

# Code / Gists
require './gist'
use Gist

# File Uploads
require './fileshuttle'
use FileShuttle

# Assets Plugin
require './assets'
use Assets

# Ktty
require './ktty'
run Ktty