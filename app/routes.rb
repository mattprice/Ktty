module Ktty
  # Routes page requests.
  module Routes
    autoload :Base, 'app/routes/base'
    autoload :Gists, 'app/routes/gists'
    autoload :Index, 'app/routes/index'
    autoload :Uploads, 'app/routes/uploads'
  end
end
