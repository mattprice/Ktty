require 'sinatra/base'

class Ktty < Sinatra::Base
  # Where possible, aliases should be submitted upstream to Rouge.
  ALIASES = {
    'objective-c' => 'objc',
  }

  # Convert the Gist API response into the correct language file.
  def get_class(language)
    language = language.downcase
    ALIASES[language] || language
  end

  get '/' do
    haml :index
  end

  not_found do
    '404 Page Not Found'
  end
end
