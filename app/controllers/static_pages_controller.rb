class StaticPagesController < ApplicationController
    def index
        begin
            if params[:username]
                flickr = Flickr.new
    
                user_nsid = flickr.people.findByUsername(username: params[:username]).nsid
            
                public_photos_list = flickr.people.getPublicPhotos(user_id: user_nsid)
    
                @photos = photos_from_list(public_photos_list)
    
                render "results"
            end
        rescue => exception
            flash.now[:error] = "Oops! Something went wrong with your search."
        end
        
    end


    private

    def url_from_photo(photo)
        "https://live.staticflickr.com/#{photo.server}/#{photo.id}_#{photo.secret}_c.jpg"
    end

    def photos_from_list(list, photos=[])
        list.each do |photo|
            photos << { title: photo.title, url: url_from_photo(photo) }
        end

        photos
    end
end
