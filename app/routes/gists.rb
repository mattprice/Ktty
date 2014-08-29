require 'json'
require 'open-uri'

module Ktty
  module Routes
    class Gists < Base
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

        # Check for Markdown files.
        # FIX: Markdown formatting doesn't work after swap to Rouge.
        # if @assets.index('markdown')
          # haml :markdown
        # else
          haml :gist
        # end
      end

      # Request the gist from the GitHub API.
      def load(id)
        # Attempt API request. If it fails, return a 404.
        # TODO: We should return something failure-specific instead of just a 404.
        return open("https://api.github.com/gists/#{id}") do |data|
          JSON.parse(data.read)
        end
      rescue OpenURI::HTTPError
        halt 404
      end

      def process(gist)
        @title  = gist['description']
        @files  = []

        # Initiate a Rouge formatter.
        formatter = Rouge::Formatters::HTML.new(css_class: 'highlight', wrap: false)

        # A gist can contain multiple files so we need to loop through each one.
        gist['files'].each do |file|
          file = file[1]

          # If there's no description, try using a filename as the title instead,
          # but ignore the default gist filename which begins with "gistfile".
          if @title.empty? && !file['filename'].start_with?('gistfile')
            @title = file['filename']
          end

          # Find the correct Rouge lexer for the given language.
          language = find_aliases file['language']
          lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText.new

          @files.push(
            'content'  => formatter.format(lexer.lex(file['content'])),
            'name'     => file['filename']
          )
        end

        # If we still don't have a page title, use the gist ID as a fallback.
        @title = "gist:#{gist['id']}" if @title.empty?
      end
    end
  end
end