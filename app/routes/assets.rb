module Ktty
  module Routes
    # Compiles and serves non-static Ktty assets.
    class Assets < Base
      configure do
        set :assets, assets = Sprockets::Environment.new(settings.root)
        assets.append_path('app/assets')

        # Compress everything during production.
        # TODO: YUI requires Java. Need to use something else...
        unless settings.development?
          assets.js_compressor  = Uglifier.new
          # assets.css_compressor = YUI::CssCompressor.new
        end
      end

      get '/css/:file' do |file|
        content_type('text/css')

        content = settings.assets[file]
        return content if content

        error 404
      end

      get '/js/:file' do |file|
        content_type('application/javascript')

        content = settings.assets[file]
        return content if content

        error 404
      end
    end
  end
end
