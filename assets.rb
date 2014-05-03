require 'sinatra/base'
require 'sprockets'
require 'uglifier'
require 'yui/compressor'

class Assets < Sinatra::Base
  configure do
    set :assets, (Sprockets::Environment.new do |config|
      config.append_path 'assets/asset-bundles'
      config.append_path 'assets/css'
      config.append_path 'assets/prism-addons'
      config.append_path 'assets/prism/components'
      config.append_path 'assets/prism/plugins/show-invisibles'

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

  # TODO: Sinatra returns status code 200 even if a file doesn't exist.
  get '/js/:file.js' do |file|
    content_type('application/javascript')
    settings.assets["#{file}.js"]
  end
end
