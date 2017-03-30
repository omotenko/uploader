require "rails_helper"

RSpec.describe Upload, :type => :model do

  it "should create one after adding any of [suppliers.csv, sku.csv]" do
    %w[suppliers.csv sku.csv].each.with_index do |file, i|
      FactoryGirl.create(:upload, attachment_file_name: file)
      expect(Upload.count).to eq i + 1
    end
  end

  it "should create none after adding not valid file_name" do
    upload = FactoryGirl.build(:upload, attachment_file_name: 'text.csv')

    expect(upload).to be_invalid
    expect(upload.errors[:attachment_file_name]).to include("is invalid")
  end

  it "should create none after adding not valid content_type" do
    upload = FactoryGirl.build(:upload, attachment_content_type: 'application/pdf')

    expect(upload).to be_invalid
    expect(upload.errors[:attachment_content_type]).to include("is invalid")
  end
end