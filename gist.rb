require 'haml'
require 'htmlentities'
require 'json'
require 'open-uri'
require './ktty'

class Gist < Ktty
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
    # TODO: This probably isn't the best solution, but it works right now.
    if @assets.index('markdown')
      haml :markdown
    else
      haml :gist
    end
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
    @assets = []
    @files  = []

    # A gist can contain multiple files so we need to loop through each one.
    gist['files'].each do |file|
      file = file[1]

      # If there's no description, try using a filename as the title instead,
      # but ignore the default gist filename which begins with "gistfile".
      if @title.empty? && !file['filename'].start_with?('gistfile')
        @title = file['filename']
      end

      language = get_class file['language']

      @assets.push(language)
      @files.push(
        'content'  => file['content'],
        'language' => language,
        'name'     => file['filename']
      )
    end

    # If we still don't have a page title, use the gist ID as a fallback.
    @title = "gist:#{gist['id']}" if @title.empty?

    # Don't load language files multiple times.
    @assets.uniq!
  end
end
