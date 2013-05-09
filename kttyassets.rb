require 'sinatra/base'
require 'sprockets'
require 'yui/compressor'

class KttyAssets < Sinatra::Base
  configure do
    set :assets, (Sprockets::Environment.new { |config|
      config.append_path 'assets/asset-bundles'
      config.append_path 'assets/css'
      config.append_path 'assets/prism-addons'
      config.append_path 'assets/prism/components'
      config.append_path 'assets/prism/plugins/show-invisibles'

      # Compress everything during production.
      # TODO: I think I'd rather use Uglifier for Javascript.
      if !settings.development?
        config.js_compressor  = YUI::JavaScriptCompressor.new
        config.css_compressor = YUI::CssCompressor.new
      end
    })
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