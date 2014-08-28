module Ktty
  module Routes
    class Uploads < Base
      get '/f/:file' do |file|
        if file =~ /\.(jpe?g|png|gif)$/i
          haml :image_upload, locals: {image: file}
        else
          redirect to("/uploads/#{file}"), 302
        end
      end
    end
  end
end