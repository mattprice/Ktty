module Ktty
  module Routes
    class Uploads < Base
      def file_url(filename)
        "/uploads/" + filename
      end

      def file_path(filename)
        "../../../public/" + file_url(filename)
      end

      get '/f/:file' do |file|
        error 404 unless File.exist? File.expand_path(file_path(file), __FILE__)

        if file =~ /\.(jpe?g|png|gif)$/i
          haml :image_upload, locals: {image: file}
        else
          redirect to file_url(file), 302
        end
      end
    end
  end
end