require "rails_helper"

RSpec.describe "Goods management", :type => :request do

  it "should render list of goods" do
    get "/goods"
    expect(response).to render_template(:index)
  end
end