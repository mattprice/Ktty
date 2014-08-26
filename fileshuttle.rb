require './ktty'

class FileShuttle < Ktty
  # Send the file directly
  get '/f/:file' do |file|
    @image_path = file
    haml :fileshuttle
  end

  # Fetch the file.
  get '/embed/:file' do |file|
    send_file File.join('public_html/embed', file)
  end
end
