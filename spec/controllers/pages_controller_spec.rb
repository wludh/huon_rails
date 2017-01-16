require 'rails_helper'

describe PagesController do
    describe "GET" 'index' do
        it "returns http success header" do
            get :index
            expect(response).to be_success
            expect(response).to have_http_status(200)
        end
    end

    describe "GET" 'an editiion page' do
        it "returns http success header" do
            get 'p_manuscript'
            expect(response).to be_success
            expect(response).to have_http_status(200)
        end

        it "reads in some TEI" do
            expect{controller.parse_tei('p.xml')}.not_to raise_error
        end

        it "gets title from the TEI" do
            @title, _, _ = controller.parse_tei('p.xml')
            expect(@title).to include('Huon')
        end

        it "gets the introduction" do
            _, @introduction, _ = controller.parse_tei('p.xml')
            expect(@introduction).to include('Biblioteca del Seminario')
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
            expect(controller.parse_line(Nokogiri::XML(line).children[0])).to eq('<l n="2">E pluy de tre any stete in la çitie</l>')
        end

        # TODO: parse the remaining tagsets that you want. also the remaining functions

        it "should get annotations" do
            expect(controller.import_notes('notes-p.xml')).to be_truthy
        end

        it "should connect annotations with the line groups" do
            @current_notes = controller.parse_and_store_notes(@note_numbers, 'p.xml')
            expect(@current_notes).to be_truthy
        end

    end

    describe "GET" 'bibliography' do
        it "returns http success header" do
            get 'bibliography'
            expect(response).to be_success
            expect(response).to have_http_status(200)
        end
    end

    describe "GET" 'pages/show' do

        it 'should render the p template' do
            get 'p_manuscript'
            expect(page).to render_template('pages/p')
        end

        it 'should render the t template' do
            get 't_manuscript'
            expect(page).to render_template('pages/t')
        end

        it 'should render the br template' do
            get 'br_manuscript'
            expect(page).to render_template('pages/br')
        end

        it 'should render the b template' do
            get 'b_manuscript'
            expect(page).to render_template('pages/b')
        end
    end
end
