require 'sinatra/base'

class Ktty < Sinatra::Base
  # Some languages share the same Prism highlighting component.
  CLASS_ALTS = {
    'c#'          => 'csharp',
    'c++'         => 'cpp',
    'd'           => 'clike',
    'html'        => 'markup',
    'json'        => 'javascript',
    'objective-c' => 'clike',
    'perl'        => 'clike',
    'rust'        => 'clike',
    'vala'        => 'clike'
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
