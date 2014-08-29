module Ktty
  module Routes
    # Handles page requests to the website root.
    class Index < Base
      get '/' do
        haml :index
      end
    end
  end
end
