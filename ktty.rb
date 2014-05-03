require 'sinatra/base'

class Ktty < Sinatra::Base
  SAMPLE_URL = 'http://ktty.co/g/5ba8b745963d9f89683b'

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
    'Syntax is <strong>http://ktty.co/g/gist_id</strong>.' \
    " Example: <a href='#{SAMPLE_URL}'>#{SAMPLE_URL}</a>"
  end

  not_found do
    '404 Page Not Found'
  end
end
