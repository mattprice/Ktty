require 'app/routes'

module Ktty
  class App < Sinatra::Application
    use Ktty::Routes::Assets
    use Ktty::Routes::Gists
    use Ktty::Routes::Index
    use Ktty::Routes::Uploads
  end
end