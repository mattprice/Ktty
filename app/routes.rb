module Ktty
  # Routes page requests.
  module Routes
    autoload :Assets, 'app/routes/assets'
    autoload :Base, 'app/routes/base'
    autoload :Gists, 'app/routes/gists'
    autoload :Index, 'app/routes/index'
    autoload :Uploads, 'app/routes/uploads'
  end
end
