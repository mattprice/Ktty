module Ktty
  module Routes
    class Base < Sinatra::Application
      configure do
        set :views, 'app/views'
        set :root, App.root
      end

      not_found do
        '404 Page Not Found'
      end
    end
 end
end