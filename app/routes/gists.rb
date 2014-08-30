require 'json'
require 'open-uri'

module Ktty
  module Routes
    # Processes and displays GitHub Gist requests.
    class Gists < Base
      FORMATTER = Rouge::Formatters::HTML.new(
        css_class: 'highlight',
        wrap: false
      )

      # Where possible, aliases should be submitted upstream to Rouge.
      ALIASES = {
        'objective-c' => 'objc'
      }

      # Convert the Gist response into the correct language file.
      def find_aliases(language)
        language = language.downcase
        ALIASES[language] || language
      end

      # Redirect empty requests.
      get '/g/' do
        redirect '/', 301
      end

      # Load and process requests for raw snippet code.
      get '/g/:snippet/raw' do |id|
        gist = load(id)
        process(gist)

        # Currently only works with Gists containing one file.
        haml :raw
      end

      # Load and process snippet requests.
      get '/g/:snippet' do |id|
        gist = load(id)
        process(gist)

        # FIX: Markdown support was removed when swapping to Rouge.
        haml :gist
      end

      # Request the gist from the GitHub API.
      def load(id)
        # TODO: Return something failure-specific instead of just a 404?
        return open("https://api.github.com/gists/#{id}") do |data|
          JSON.parse(data.read)
        end
      rescue OpenURI::HTTPError
        halt 404
      end

      def process(gist)
        @title = ''
        @desc  = gist['description']
        @files = []

        # A gist can contain multiple files.
        gist['files'].each do |file|
          file = file[1]

          # The default "gistfile1.ext" filename is useless, so get rid of it.
          file['filename'] = '' if file['filename'].start_with?('gistfile')

          # Find the correct Rouge lexer for the given language.
          language = find_aliases file['language']
          lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText.new

          @files.push(
            'content'  => FORMATTER.format(lexer.lex(file['content'])),
            'name'     => file['filename']
          )
        end

        # A filename is the preferred page title if there is only one file.
        @title = @files[0]['name'] if @files.count == 1

        # Use the description or gist ID if there are multiple files.
        if @title.empty?
          @title = @desc || "gist:#{gist['id']}"
          @desc = ''
        end
      end
    end
  end
end
