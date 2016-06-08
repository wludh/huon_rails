require 'rails_helper'

describe PagesController do
    describe "GET" 'index' do
        it "returns http success header" do
            get :index
            expect(response).to be_success
            expect(response).to have_http_status(200)
        end
    end

    describe "GET" 'p_manuscript' do
        it "returns http success header" do
            get :index
            expect(response).to be_success
            expect(response).to have_http_status(200)
        end

        it "reads in some TEI" do
            expect{controller.parse_tei('p.xml')}.not_to raise_error
        end

        it "gets title from the TEI" do
            @title, _, _ = controller.parse_tei('p.xml')
            @title.should include('Huon')
        end

        it "gets the introduction" do
            _, @introduction, _ = controller.parse_tei('p.xml')
            @introduction.should include('Biblioteca del Seminario')
        end

        it "gets the line groups and can parse them" do
            _, _, @line_groups = controller.parse_tei('p.xml')
            expect{controller.parse_line_groups(@line_groups)}.not_to raise_error
        end

        it "should parse the TEI and return an HTML safe string" do
            _, _, @line_groups = controller.parse_tei('p.xml')
            expect(controller.parse_line_groups(@line_groups).html_safe?).to be_truthy
        end

        it "should parse a line" do
            line = '<l n="2">E pluy de tre any stete in la çitie</l>'
            controller.parse_line(Nokogiri::XML(line).children[0]).should == '<l n="2">E pluy de tre any stete in la çitie</l>'
        end

        # TODO: parse the remaining tagsets that you want. also the remaining functions

        it "should connect to the annotations" 

        it "should load the annotations" 

        it "should link annotations with lines" 
    end

    describe "GET" 'bibliography' do
        it "should be pulling in the zotero bibliogaphy" do
        end
    end
end
