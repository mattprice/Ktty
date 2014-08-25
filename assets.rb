require 'sinatra/base'
require 'sprockets'
require 'uglifier'
require 'yui/compressor'

class Assets < Sinatra::Base
  configure do
    set :assets, (Sprockets::Environment.new do |config|
      config.append_path 'assets/css'
      config.append_path 'public_html/images'

      # Compress everything during production.
      # TODO: YUI requires Java. Need to use something else...
      unless settings.development?
        config.js_compressor  = Uglifier.new
        # config.css_compressor = YUI::CssCompressor.new
      end
    end)
  end

  get '/css/ktty.css' do
    content_type('text/css')
    settings.assets['ktty.css']
  end

  get '/css/pygments.css' do
    content_type('text/css')
    settings.assets['pygments.css']
  end

  get '/images/kitten.jpg' do
    content_type('image/jpeg')
    settings.assets['kitten.jpg']
  end
end
