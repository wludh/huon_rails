class PagesController < ApplicationController
	skip_before_action :verify_authenticity_token
    def show
        render template: "pages/#{params[:page]}"
    end
    def parse_tei(tei_file)
        file = File.open( "./lib/assets/#{tei_file}" )
        doc = Nokogiri::XML(file)
        @title = doc.search('title').first.text

        # placeholder for if Steve decides to include bylines for authors.
        # @by_line = doc.search('INSERT').text
        @introduction = doc.search('note').first.text
        @text = doc.search('text').text
        @line_groups = doc.search('lg')
        return @title, @introduction, @text, @line_groups
    end
    helper_method :parse_tei
end  
