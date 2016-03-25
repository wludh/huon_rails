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

    def parse_tag(tag_child)
        #Takes a nodeset with no children and parses it. Must be well-formed and have no tags nested within it. ie. '<ex>word</ex>.'
        return "<#{tag_child.name}>#{tag_child.text}</#{tag_child.name}>".html_safe
    end
    
    # def parse_line(line_nodeset)
    #     #{"""}Takes a nodeset (line) and parses it
    #     for child in line_nodeset
    #         open_tag_set = ""
    #         close_tag_set = ""
    #         if child.name == 'text'
    #             child.text
    #         elsif child.children.present?
    #             # if there are children, start looking for the subchildren. 
    #             open_tag_set += "<#{child.name}>"
    #             close_tag_set += "</#{child.name}>"
    #             for subchild in child.children
    #                 if subchild.children.blank?
    #                     #if there are no children, just return a blank tag.
    #                     "#{open_tag_set}#{close_tag_set}".html_safe
    #                 elsif sub_child.name == 'text'
    #                     # if the subchild is just text, return the text
    #                     subchild.text.html_safe
    #                 else
    #                     if there 
    #                 end
    #             end
    #             parse_line(child)
    #         end
    #     end
    #     # if a line has nested tags, preserve them.
    # end

    def parse_empty_tag(nodeset)
        return "<#{child.name}></#{child.name}>".html_safe
    end

    # def parse_choice(choice_nodeset)
    #     #outside
    #     tags = []
    #     for child in choice_nodeset.children
    #         tags = tags.push(child.name)

    #     end
    # end

    helper_method :parse_empty_tag
    helper_method :parse_tag
    helper_method :parse_tei
    helper_method :parse_line

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
