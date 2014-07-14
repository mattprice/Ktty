require './ktty'

class FileShuttle < Ktty
  # Send the file directly
  get '/f/:file' do |file|
    send_file File.join('f', file)
  end
end
