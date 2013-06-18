require 'haml'
require 'htmlentities'
require 'json'
require 'open-uri'
require './ktty'

class Pastebin < Ktty
  # Redirect empty requests.
  get '/p/' do
    redirect '/', 301
  end

  # Load and process snippet requests.
  get '/p/:snippet' do |id|
    # Pastebin doesn't have a great API, so all that's returned is the content
    # and no other information about the actual snippet...
    @content = load(id)

    # Use the snippet ID as the page title.
    @title = "snippet:#{id}"

    haml :pastebin
  end

  # Request the snippet from the Pastebin API.
  def load(id)
    # Attempt API request. If it fails, return a 404.
    # TODO: The request could fail for multiple reasons. We should return something failure-specific.
    begin
      return open("http://pastebin.com/raw.php?i=#{id}").read
    rescue OpenURI::HTTPError
      halt 404
    end
  end
end