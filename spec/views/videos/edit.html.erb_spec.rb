require 'rails_helper'

RSpec.describe "videos/edit", type: :view do
  before(:each) do
    @video = assign(:video, Video.create!(
      :filename => "MyString",
      :content_type => "MyString",
      :file_contents => ""
    ))
  end

  it "renders the edit video form" do
    render

    assert_select "form[action=?][method=?]", video_path(@video), "post" do

      assert_select "input[name=?]", "video[filename]"

      assert_select "input[name=?]", "video[content_type]"

      assert_select "input[name=?]", "video[file_contents]"
    end
  end
end
