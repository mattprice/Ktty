require 'app/routes'

module Ktty
  # Loads routes and sets up defaults for the Ktty application.
  class App < Sinatra::Application
    use Ktty::Routes::Assets
    use Ktty::Routes::Gists
    use Ktty::Routes::Index
    use Ktty::Routes::Uploads
  end
end
