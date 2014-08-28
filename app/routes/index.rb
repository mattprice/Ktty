module Ktty
  module Routes
    class Index < Base
      get '/' do
        haml :index
      end
    end
  end
end