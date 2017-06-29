require 'roman-numerals'

class PagesController < ApplicationController

	skip_before_action :verify_authenticity_token
    # patch for using will-paginate gem to paginate through laisses
    require 'active_support/core_ext/array/conversions.rb'

    def show
        # convert the pages parameter into the tidy slug
        render template: "pages/#{params[:page]}"
    end

    def import_tei(tei_file)
        # take the tei file name and return a nokogiri object
        return File.open( "./lib/assets/#{tei_file}" ) {
                |f| Nokogiri::XML(f)
            }
    end

    def parse_tei(tei_file, testing=false)
        unless params.key?('edition') or not testing
            # look for the edition param to let us know if we're at the intro or not.
            # if no page / if at edition, show the intro.

            # import the tei
            doc = import_tei(tei_file)

            # get the title
            @title = doc.search('title').first.text

            # get the introduction
            @introduction = doc.search('note').first.text

            return @title, @introduction
        else

            # get the doc
            doc = import_tei(tei_file)

            # get the title
            @title = doc.search('title').first.text

            if doc.search('title[type="short"]').length > 1
                @short_title = doc.search('title[type="short"]').text
            else
                @short_title = "Navigation"
            end

            # get the introduction
            @introduction = doc.search('note').first.text

            # get all line groups but paginate through them so only showing the current one.
            @line_groups = doc.css('lg').to_a.paginate(:page => params[:page], :per_page => 1)

            # keeping note numbers consistent across laisses
            @@internal_note_counter = 1

            # current notes for this laisse
            @current_notes = parse_and_store_notes(tei_file)

            # chunk up the TEI so we only see the laisse we are on.
            @simple_tei = parsing_for_tei_embed(doc, params[:page])

            return @title, @line_groups, @gist_id, @simple_tei
        end
    end


    def parsing_for_tei_embed(doc, page_num)
        # restructures TEI and throws away all but the laisse we're looking at.

        # it no page_num is present assume page one.
        page_num ||= "1"

        # grab the active laisse and store it for next step
        active_laisse = doc.search('lg[n="'+ page_num + '"]')

        # get all laisses and throw them away
        laisses = doc.search('lg')
        laisses.remove()

        # strip out all empty lines (to offset wierd quirk of Nokogiri's when it removes nodes.)
        doc.xpath('//text()').find_all {|t| t.to_s.strip == ''}.map(&:remove)

        # add the active laisse back in.
        doc.at_css('body').add_child(active_laisse)

        return doc.to_xml
    end

    def import_notes(tei_file)
        # Import notes from TEI file.
        doc = File.open("./lib/assets/#{tei_file}"){
            |f| Nokogiri::XML(f)
        }
        return doc.css('respStmt'), doc.css('note')
    end

    def parse_and_store_notes(tei_file)
        # pulls notes out of the tei file.
        # ms file name to note file name
        manuscript_to_notes = {
            'p.xml' => 'notes-p.xml',
            'br.xml' => 'notes-br.xml',
            't.xml' => 'notes-t.xml',
            'b.xml' => 'notes-b.xml',
						'translation-b.xml' => 'notes-translation-b.xml',
        }

        # get the author and note nodes from the notes file
        @authors, @all_notes = import_notes(manuscript_to_notes[tei_file])

        # go through each author node and pull out the author name
        @author_hash = {}
        for author in @authors
            @author_hash[author.children[1].attributes['id'].value] = author.children[1].text
        end

        # build up the html for the notes from the parser and what we have.
        html = ""
        note_counter = 1
        for note in @all_notes
            unless note.parent.name == "notesStmt" or note.parent.name == 'head'
                if note.attributes['resp'] != nil
                    @resp = note.attributes['resp'].value
                else
                    @resp = "Anonymous"
                end

                if note.attributes['type'] != nil
                    @type = note.attributes['type'].value
                else
                    @type = "nil"
                end

                if note.values[0].to_s.sub(/\./, '')
                    @xmlid = note.values[0].to_s.sub(/\./, '')
                else
                    @xmlid = "nil"
                end

                if @author_hash[@resp.sub(/#/, '')] != nil
                    @author = @author_hash[note.attributes['resp'].value.sub(/#/, '')]
                else
                    @author = "Anonymous"
                end

                html += "<note n=\"#{note_counter}\" resp=\"#{@resp}\" type=\"#{@type}\" xml=\"#{@xmlid}\">#{note_counter}: #{note.text}<div class=\"resp\">--#{@author}</div></note><div id=\"clear\"></div><hr class=\"divider\" n=\"#{note_counter}\">"
                note_counter += 1
            end
        end
        html.html_safe
    end

    def parse_note(child, internal_note_counter)
        # take the xmlid and strip out the problematic punctuation
        xmlid = child.values.to_s.gsub(/\[|\]|\.|\"/, '')

        # parse the notes
        note_id = internal_note_counter.to_s
        ('<note rightnum="' + xmlid + '" id="'+ note_id + '"/><sup>' + '</sup></note>').html_safe
    end

    def parse_pb(line)
        # parses page break tag
        (('<div id="page-break">') + ("page: " + line.css('pb').attr('n').text) + "</div>").html_safe
    end

    def parse_milestone(line)
        (('<div class="milestone pb">') + line.css('milestone').attr('unit') + ' ' + line.css('milestone').attr('n').text + '</div>').html_safe
    end

    def parse_heading(line_group)
        # parses line group
        heading_number = line_group.search('head').text.gsub(/Laisse /, '').to_i
        ('<div class="line-heading">Laisse ' + RomanNumerals.to_roman(heading_number) + "</div>").html_safe
    end

    def parse_tag(tag_child)
        #Takes a nodeset with no children and parses it. Must be well-formed and have no tags nested within it. ie. '<ex>word</ex>.'
        if tag_child.attributes['rend']
            return "<#{tag_child.name} rend=\"#{tag_child.attributes['rend'].value}\">#{tag_child.text}</#{tag_child.name}>".html_safe
        else
            return "<#{tag_child.name}>#{tag_child.text}</#{tag_child.name}>".html_safe
        end
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

		def parse_seg(child)
			result = "<seg resp=#{child.attr('resp')}>"
			result += child.text
			result += "</seg>"
			return result.html_safe
		end

    def parse_line(l)
        result =""
        # parses a line where 'l' is a line_nodeset
        if (l.attr('n').to_i % 5) == 0
            result += "<div class=\"linenumber\">" + l.attr('n').to_s + "</div>"
        end
        if l.css('milestone').present?
            result += parse_milestone(l)
        end
        result += "<l n=\"#{l.attr('n')}\">"
            if l.css('pb').present?
                result += parse_pb(l)
            end
             for child in l.children
                 if child.name == 'choice'
                    result += parse_choice(child)
                 elsif child.name == 'ex'
                    result += parse_tag(child)
                     # add any new tags in the following array.
                elsif ['cb', 'corr', 'rubric', 'ab', 'lb', 'hi'].include? child.name
                    result += parse_tag(child)
								elsif child.name == 'seg'
										result += parse_seg(child)
                elsif child.name == 'note'
                    result += parse_note(child, @@internal_note_counter)
                    @@internal_note_counter += 1
                 else
                    result += child.text
                 end
             end
        result += "</l>"
        return result.html_safe
    end

    def vmachine_import(tei_file)
    # not implemented - stubbing out functionality for
    # rewriting the versioning machine implementation.
    # First get a list of the files.
    # For each of the files in that list, pull in the TEI
    # Get the lines you want.
    # Reformat them to be in the format you want.
    parsed_material = ""
        for file in tei_files
            tei_files = ['p.xml', 'b.xml', 't.xml', 'br.xml', 'translation-b.xml',]
            tag = INSERT_THE_TAG_TO_DRAW_FROM_HERE
            @all_tags = file.css(tag)
            file = import_tei(tei_file)
            @loci, @rdgs = INSERT_WAY_TO_PARSE_HERE
            parsed_material += STUFF TO ADD
        end

        parsed_material
    end


    def vmachine_parser(list_of_manuscripts)

    end


    helper_method :import_notes
    helper_method :get_all_notes
    helper_method :parse_and_store_notes
    helper_method :parse_choice
    helper_method :parse_pb
    helper_method :parse_heading
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

		def encod_praxis
			render template: "pages/encod_praxis"
		end

		def intro_praxis
				render template: "pages/intro_praxis"
		end

		def b_manuscript
        parse_tei('b.xml')
        render template: "pages/b"
    end

		def b_praxis
			render template: "pages/b_praxis"
		end

    def t_manuscript
        parse_tei('t.xml')
        render template: "pages/t"
    end

		def t_praxis
			render template: "pages/t_praxis"
		end

    def p_manuscript
        parse_tei('p.xml')
        render template: "pages/p"
    end

		def p_praxis
			render template: "pages/p_praxis"
		end

    def br_manuscript
        parse_tei('br.xml')
        render template: "pages/br"
    end

		def br_praxis
			render template: "pages/br_praxis"
		end

		def b_translation
			parse_tei('translation-b.xml')
			render template: "pages/translation-b"
		end

    def hell_scene
        render template: "pages/hell_scene"
    end
end
