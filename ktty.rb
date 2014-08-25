require 'sinatra/base'

class Ktty < Sinatra::Base
  # GitHub and Rouge don't always use the same language code.
  CLASS_ALTS = {
    # 'c#'          => 'csharp',
    # 'c++'         => 'cpp',
  }

  # Convert the Gist API response into the correct language file.
  def get_class(language)
    language = language.downcase
    CLASS_ALTS[language] || language
  end

  get '/' do
    haml :index
  end

  not_found do
    '404 Page Not Found'
  end
end
