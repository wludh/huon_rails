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

    def parse_pb(line)
        return (('<div id="page-break">') + ("page: " + line.css('pb').attr('n').text) + "</div>").html_safe
    end

    def parse_heading(line_group)
        return ('<div class="line-heading">' + line_group.search('head').text + "</div>").html_safe
    end

    def parse_tag(tag_child)
        #Takes a nodeset with no children and parses it. Must be well-formed and have no tags nested within it. ie. '<ex>word</ex>.'
        return "<#{tag_child.name}>#{tag_child.text}</#{tag_child.name}>".html_safe
    end

    def parse_choice(tag_set)
        # takes a choice nodeset that
        result = "<choice>"
        for choice_child in tag_set.children
            result += "<#{choice_child.name}>#{choice_child.text}</#{choice_child.name}>"
        end
        result += "</choice>"
        return result.html_safe
    end

    def parse_annotation(child)
        # stub function for basic footnote functionality. Will eventually need to take in the note number.

        return ('<annotation n="1">' + "#{child.text}" + '</annotation><sup onclick="annotation_reveal(1)">*</sup>').html_safe
    end
    
    def parse_line_groups(line_groups)
         result = ""
         @line_groups.each do |line_group| 
             result += parse_line_group(line_group)
         end
         return result.html_safe
    end

    def parse_line_group(line_group)
        #takes in a line_group and parses it 
        result = "<lg n=#{line_group.attr('n')}>" 
        result += parse_heading(line_group) 
        result += '<div class="lines">'
        for l in line_group.css('l') 
             result += parse_line(l) 
        end 
        result += '</div></lg>'
        return result.html_safe
    end

    def parse_line(l)
        # parses a line where 'l' is a line_nodeset
        result = "<l n=#{l.attr('n')}>"
                 if l.css('pb').present? 
                    result += parse_pb(l)
                 end 
             for child in l.children 
                 if child.name == 'choice' 
                    result += parse_choice(child)
                 elsif child.name == 'ex'     
                    result += parse_tag(child) 
                    # The following two elsif statements are entirely just for testing note functionality.
                 elsif child.text == "Ni de mare ni de pare se l'avesse inçenerie;"
                    result += '<annotation n="3" onclick="annotation_reveal(3)">' + "#{child.text}" + '</annotation><sup onclick="annotation_reveal(3)">*</sup>'
                 elsif child.text == "Che in lo conte Ugo aveva messo so pensie;" 
                    result += parse_annotation(child) 
                 else 
                    result += child.text 
                 end 
             end 
        result += "</l>"
        return result.html_safe
    end

    def parse_empty_tag(nodeset)
        return "<#{child.name}></#{child.name}>".html_safe
    end

    helper_method :parse_annotation
    helper_method :parse_choice
    helper_method :parse_pb
    helper_method :parse_heading
    helper_method :parse_empty_tag
    helper_method :parse_tag
    helper_method :parse_tei
    helper_method :parse_line
    helper_method :parse_line_group
    helper_method :parse_line_groups

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
