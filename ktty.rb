require 'sinatra/base'

class Ktty < Sinatra::Base
  # Convert the Gist API response into the correct language file.
  def get_class(language)
    # Some languages share the same Prism highlighting component.
    class_name = {
      'c#'          => 'clike',
      'c++'         => 'cpp',
      'd'           => 'clike',
      'go'          => 'clike',
      'html'        => 'markup',
      'json'        => 'javascript',
      'objective-c' => 'clike',
      'perl'        => 'clike',
      'php'         => 'clike',
      'rust'        => 'clike',
      'vala'        => 'clike',
    }

    language = language.downcase
    class_name[language] || language
  end

  get '/' do
    'Hello, world!'
  end

  not_found do
    '404 Page Not Found'
  end
end