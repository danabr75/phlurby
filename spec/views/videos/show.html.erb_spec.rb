require 'rails_helper'

RSpec.describe "videos/show", type: :view do
  before(:each) do
    @video = assign(:video, Video.create!(
      :filename => "Filename",
      :content_type => "Content Type",
      :file_contents => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Filename/)
    expect(rendered).to match(/Content Type/)
    expect(rendered).to match(//)
  end
end
