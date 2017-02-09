require 'rails_helper'

def manuscript_block(manuscript, route)
    it "returns http success header - #{manuscript}" do
        get route
        expect(response).to be_success
        expect(response).to have_http_status(200)
    end

    it "reads in some TEI - #{manuscript}" do
        expect{controller.parse_tei(manuscript)}.not_to raise_error
    end

    it "gets title from the TEI - #{manuscript}" do
        @title, _, _ = controller.parse_tei(manuscript)
        expect(@title).to include('Huon')
    end

    it "gets the introduction - #{manuscript}" do
        _, @introduction, _ = controller.parse_tei(manuscript, true)

        expect(@introduction).to be_truthy
    end

    it "gets the line groups and can parse them - #{manuscript}" do
        _, _, @line_groups = controller.parse_tei(manuscript)
        expect{controller.parse_line_groups(@line_groups)}.not_to raise_error
    end

    it "should parse the TEI and return an HTML safe string - #{manuscript}" do
        _, _, @line_groups = controller.parse_tei(manuscript)
        expect(controller.parse_line_groups(@line_groups).html_safe?).to be_truthy
    end

    it "should get annotations - #{manuscript}" do
        expect(controller.import_notes('notes-' + manuscript)).to be_truthy
    end

    it "should connect annotations with the line groups - #{manuscript}" do
        @current_notes = controller.parse_and_store_notes(@note_numbers, manuscript)
        expect(@current_notes).to be_truthy
    end

    describe "GET " 'pages templates' do

        it "should render the manuscript template - #{manuscript}" do
            get route
            unless route[1] == 'r'
                expect(page).to render_template('pages/' + route[0])
            else
                expect(page).to render_template('pages/' + route[0..1])
            end
        end
    end
end

def note_block(note, file)
    it "should have a resp statement - note for #{file}: #{note}" do
        expect(note.attributes['resp']).to be_truthy
    end

    it "should have a n attribute - note for #{file}: #{note}" do
        expect(note.attributes['n']).to be_truthy
    end

    it "should have a type attribute - note for #{file}: #{note}" do
        expect(note.attributes['type']).to be_truthy
    end

    it "should have an xml id - note for #{file}: #{note}" do
        expect(note.attributes['id'].namespace.prefix).to eq("xml")
    end
end

describe PagesController do
    describe "GET " 'index' do
        it "returns http success header" do
            get :index
            expect(response).to be_success
            expect(response).to have_http_status(200)
        end
    end

    describe "GET " 'an edition page' do
        manuscripts = ['p.xml', 't.xml', 'br.xml', 'b.xml']
        routes = {'p.xml'=> 'p_manuscript', 't.xml' => 't_manuscript' , 'br.xml' => 'br_manuscript', 'b.xml' => 'b_manuscript'}
        for manuscript in manuscripts
            manuscript_block(manuscript, routes[manuscript])
        end
    end

    describe "GET " 'a note ' do
        note_files = ['notes-b.xml', 'notes-br.xml', 'notes-p.xml', 'notes-t.xml']
        for file in note_files
            doc = File.open("./lib/assets/#{file}"){
                    |f| Nokogiri::XML(f)
                }
            notes = doc.css('note')
            for note in notes
                note_block(note, file)
            end
        end
    end

    describe "GET " 'the hell scene page' do
        it 'should render the page template' do
            get 'hell_scene'
            expect(page).to render_template('pages/hell_scene')
        end
    end

    describe "GET " 'the editions page' do
        it 'should render the page template' do
            get 'editions'
            expect(page).to render_template('pages/edition')
        end
    end

    describe "GET " 'bibliography' do
        it "returns http success header" do
            get 'bibliography'
            expect(response).to be_success
            expect(response).to have_http_status(200)
        end
    end

    describe "the parser" do
        it "should parse choice tag 1" do
            line = '<l n="2"><choice><abbr>xpo</abbr><ex>cristo</ex></choice></l>'
            expect(
                controller.parse_line(Nokogiri::XML(line).children[0])).to eq('<l n="2"><choice><abbr>xpo</abbr><ex>cristo</ex></choice></l>')
        end
        it "should parse choice tag 2" do
            line = '<l n="2"><choice><abbr></abbr><expan><ex></ex></expan></choice></l>'
            expect(
                controller.parse_line(Nokogiri::XML(line).children[0])).to eq('<l n="2"><choice><abbr></abbr><expan><ex></ex></expan></choice></l>')
        end
        it "should parse choice tag 3 and convert unicode character" do
            line = '<l n="2"><choice><abbr>&#x17f;vir</abbr><expan>s<ex>er</ex>vir</expan></choice></l>'
            expect(
                controller.parse_line(Nokogiri::XML(line).children[0])).to eq('<l n="2"><choice><abbr>ſvir</abbr><expan>s<ex>er</ex>vir</expan></choice></l>')
        end
        it "should parse choice tag 4 and convert unicode character" do
            line = '<l n="2"><choice><abbr>&#xa751;</abbr><expan>p<ex>er</ex></expan></choice></l>'
            expect(
                controller.parse_line(Nokogiri::XML(line).children[0])).to eq('<l n="2"><choice><abbr>ꝑ</abbr><expan>p<ex>er</ex></expan></choice></l>')
        end
        it "should parse a corr tag" do
            line = '<l n="2">E <corr>pluy</corr> de tre any stete in la çitie</l>'
            expect(controller.parse_line(Nokogiri::XML(line).children[0])).to eq('<l n="2">E <corr>pluy</corr> de tre any stete in la çitie</l>')
        end
        it "should parse an 'ab' tag" do
            line = '<l n="2">E pluy de <ab>tre</ab> any stete in la çitie</l>'
            expect(controller.parse_line(Nokogiri::XML(line).children[0])).to eq('<l n="2">E pluy de <ab>tre</ab> any stete in la çitie</l>')
        end
        it "should parse an 'lb' tag" do
            line = '<l n="2">E pluy de tre <lb></lb>any stete in la çitie</l>'
            expect(controller.parse_line(Nokogiri::XML(line).children[0])).to eq('<l n="2">E pluy de tre <lb></lb>any stete in la çitie</l>')
        end
        it "should parse a general line" do
            line = '<l n="2">E pluy de tre any stete in la çitie</l>'
            expect(controller.parse_line(Nokogiri::XML(line).children[0])).to eq('<l n="2">E pluy de tre any stete in la çitie</l>')
        end
        it "should parse everything at once" do
            line = '<l n="2">E <corr>pluy</corr> <lb></lb>de <ab>tre</ab> any stete in la çitie</l>'
        expect(controller.parse_line(Nokogiri::XML(line).children[0])).to eq('<l n="2">E <corr>pluy</corr> <lb></lb>de <ab>tre</ab> any stete in la çitie</l>')
        end
    end
end