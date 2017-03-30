require "rails_helper"

RSpec.describe "Upload management", :type => :request do

  it "should render correct template" do
    get "/uploads/new"
    expect(response).to render_template(:new)
  end
end