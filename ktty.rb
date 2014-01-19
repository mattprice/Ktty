require 'sinatra/base'

class Ktty < Sinatra::Base
  # Convert the Gist API response into the correct language file.
  def get_class(language)
    # Some languages share the same Prism highlighting component.
    class_name = {
      'c#'          => 'csharp',
      'c++'         => 'cpp',
      'd'           => 'clike',
      'json'        => 'javascript',
      'objective-c' => 'clike',
      'perl'        => 'clike',
      'rust'        => 'clike',
      'vala'        => 'clike',
    }

    language = language.downcase
    class_name[language] || language
  end

  get '/' do
    'Syntax is <strong>http://ktty.co/g/gist_id</strong>. Example: <a href="http://www.ktty.co/g/5ba8b745963d9f89683b">http://www.ktty.co/g/5ba8b745963d9f89683b</a>'
  end

  not_found do
    '404 Page Not Found'
  end
end