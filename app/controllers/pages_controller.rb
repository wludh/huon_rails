class PagesController < ApplicationController
	skip_before_action :verify_authenticity_token
    def show
        render template: "pages/#{params[:page]}"

    end
end  
