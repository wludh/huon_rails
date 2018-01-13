require 'rails_helper'

manuscripts = ['p.xml', 't.xml', 'br.xml', 'b.xml']
routes = {'p.xml'=> 'p_manuscript', 't.xml' => 't_manuscript' , 'br.xml' => 'br_manuscript', 'b.xml' => 'b_manuscript'}


RSpec.describe "routing to pages", :type => :routing do
    for manuscript in manuscripts
        it "routes pages to the page view" do
            expect(:get => "pages/" + routes[manuscript]).to route_to(
                :controller => "pages",
                :action => "show",
                :page => routes[manuscript])
        end
    end
end
