require 'rails_helper'

describe "GET" 'bibliography' do
    # note: both of these tests will fail if using the manually entered zotero bibliography. Because it's checking that the bibliography was entered correctly and that it has attached coins.

    it "should have coins" do
        visit 'bibliography'
        expect(page).to have_selector('.Z3988')
    end

    it "should be pulling in the zotero bibliogaphy" do
        visit 'bibliography'
        expect(page).to have_selector('.bibshowhide')
    end
end

