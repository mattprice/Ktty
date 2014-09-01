module Ktty
  module Routes
    # Handles 404 requests and sets sensible defaults for all page views.
    class Base < Sinatra::Application
      configure do
        set :views, 'app/views'
        set :root, File.expand_path('../../../', __FILE__)

        register Sinatra::AssetPack
        assets do
          prebuild true

          serve '/js',  from: 'app/assets/javascripts'
          serve '/css', from: 'app/assets/stylesheets'

          js :app, '/js/app.js', [
            '/js/**/*'
          ]

          css :app, '/css/app.css', [
            '/css/**/*',
          ]

          js_compression :uglify
          css_compression :sass
        end
        set :assets, assets

        Haml::Options.defaults[:escape_html] = true
      end

      not_found do
        '404 Page Not Found'
      end
    end
  end
end
