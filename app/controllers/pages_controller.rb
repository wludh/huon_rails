class PagesController < ApplicationController
	skip_before_action :verify_authenticity_token
    require 'active_support/core_ext/array/conversions.rb'
    
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
        @line_groups = doc.css('lg').to_a.paginate(:page => params[:page], :per_page => 1)
        @note_numbers = get_notes_for_line_group(@line_groups)
        @current_notes = parse_and_store_notes(@note_numbers)
        return @title, @introduction, @line_groups
    end


    def import_notes(tei_file)
        doc = File.open("./lib/assets/#{tei_file}"){
            |f| Nokogiri::XML(f)
        }
        doc.css('note')
    end

    def parse_and_store_notes(note_numbers)
        # note that you're not actually using the note numbers just yet
        # you're here trying to link up the list of note numbers with the notes from the file
        # takes the list of note numbers that you want and pulls them out of the tei file.
        @all_notes = import_notes('notes-p.xml')
        html = ""
        for note in @all_notes
            html += "<note n=\"#{note.attributes['n'].value}\" resp=\"#{note.attributes['resp'].value}\">#{note.text}</note>"
        end
        # @current_notes = {}
        # for when/if you can eventually pull out only those notes.
        # for number in line_group_numbers
        #     @current_notes[number] = ()
        # end
        # puts @all_notes.xpath('@xmlid:')
        html.html_safe
    end

    # def generate_note_html(notes)
    #     for note in notes
    #         "".html_safe
    #     end
    # end

    def get_notes_for_line_group(line_group)
        # gets all the notes for a line group and stores them as an array so that you can
        notes = line_group[0].css('note')
        search_array = []
        for note in notes
            search_array << note.attributes['id'].value.sub(/[A-Za-z]|#/,'')
        end
        search_array
    end

    def parse_note(child)
        note_id = child.attributes['id'].value.gsub('#', '')
        # following line should take P1 and return just 1. so remove everything that is a letter
        ('<note id="'+ note_id + '"/><sup onclick=annotation_reveal(' + note_id.sub(/[A-Za-z]/,'') + ')>' + note_id.sub(/[A-Za-z]/,'') + '</sup></note>').html_safe
    end

    def parse_pb(line)
        (('<div id="page-break">') + ("page: " + line.css('pb').attr('n').text) + "</div>").html_safe
    end

    def parse_heading(line_group)
        ('<div class="line-heading">' + line_group.search('head').text + "</div>").html_safe
    end

    def parse_tag(tag_child)
        #Takes a nodeset with no children and parses it. Must be well-formed and have no tags nested within it. ie. '<ex>word</ex>.'
        "<#{tag_child.name}>#{tag_child.text}</#{tag_child.name}>".html_safe
    end

    def parse_choice(tag_set)
        # takes a choice nodeset that contains children and parses it. Only goes down one level.
        result = "<choice>"
        for choice_child in tag_set.children
            if choice_child.name == 'expan'
                subresult = "<expan>"
                for subchild in choice_child.children
                    if subchild.name == 'text'
                        subresult += subchild.text
                    else
                        subresult += parse_tag(subchild)
                    end
                end
                subresult += "</expan>"
                result += subresult
            else
                result += "<#{choice_child.name}>#{choice_child.text}</#{choice_child.name}>"
            end
        end
        result += "</choice>"
        result.html_safe
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
        result = "<l n=\"#{l.attr('n')}\">"
                 if l.css('pb').present? 
                    result += parse_pb(l)
                 end 
             for child in l.children 
                 if child.name == 'choice' 
                    result += parse_choice(child)
                 elsif child.name == 'ex'     
                    result += parse_tag(child) 
                    # The following two elsif statements are entirely just for testing note functionality.
                #probably this? 
                #elsif ['cb', 'rubric', 'ab', 'lb'].include? child.name
                elsif child.name == 'cb'
                    result += parse_tag(child)
                elsif child.name == 'rubric'
                    result += parse_tag(child)
                elsif child.name == 'ab'
                    result += parse_tag(child)
                elsif child.name == 'lb'
                    result += parse_tag(child)
                elsif child.name == 'note'
                    result += parse_note(child)
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

    helper_method :import_notes
    helper_method :get_all_notes
    helper_method :parse_and_store_notes
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
    helper_method :parse_and_store_notes


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
        parse_tei('b.xml')
        render template: "pages/b"
    end

    def t_manuscript
        parse_tei('t.xml')
        render template: "pages/t"
    end

    def p_manuscript
        parse_tei('p.xml')
        render template: "pages/p"
    end

    def br_manuscript
        parse_tei('br.xml')
        render template: "pages/br"
    end

    def hell_scene
        render template: "pages/hell_scene"
    end
end  
