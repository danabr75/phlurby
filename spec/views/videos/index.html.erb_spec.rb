require 'rails_helper'

RSpec.describe "videos/index", type: :view do
  before(:each) do
    assign(:videos, [
      Video.create!(
        :filename => "Filename",
        :content_type => "Content Type",
        :file_contents => ""
      ),
      Video.create!(
        :filename => "Filename",
        :content_type => "Content Type",
        :file_contents => ""
      )
    ])
  end

  it "renders a list of videos" do
    render
    assert_select "tr>td", :text => "Filename".to_s, :count => 2
    assert_select "tr>td", :text => "Content Type".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
