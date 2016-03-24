class PagesController < ApplicationController
	skip_before_action :verify_authenticity_token
    
    def show
        render template: "pages/#{params[:page]}"
    end

    def parse_tei(tei_file)
        doc = File.open( "./lib/assets/#{tei_file}" ) {
            |f| Nokogiri::XML(f)
        }
        @title = doc.search('title').first.text

        # placeholder for if Steve decides to include bylines for authors.
        # @by_line = doc.search('INSERT').text
        @introduction = doc.search('note').first.text
        @line_groups = doc.css('lg')
        return @title, @introduction, @text, @line_groups
    end

    helper_method :parse_tei

    def index
        render template: 'pages/index'
    end

    def bibliography
        render template: "pages/bibliography"
    end

    def editions
        render template: "pages/edition"
    end

    def b_manuscript
        render template: "pages/b"
    end

    def t_manuscript
        render template: "pages/t"
    end

    def p_manuscript
        render template: "pages/p"
    end

    def br_manuscript
        render template: "pages/br"
    end

    def hell_scene
        render template: "pages/hell_scene"
    end
end  
