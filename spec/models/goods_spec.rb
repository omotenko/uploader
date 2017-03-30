require "rails_helper"

RSpec.describe Goods, :type => :model do

  it "should create none if supplier not exist" do
    begin
      FactoryGirl.create(:goods)
    rescue ActiveRecord::RecordInvalid => e
      expect(e.message).to eq "Validation failed: Supplier must exist"
    end
  end

  context "with supplier" do
    before :each do
      FactoryGirl.create(:supplier)
    end

    it "should create one after adding one" do
      goods = FactoryGirl.create(:goods)

      expect(Goods.count).to eq 1
      expect([goods.sku, goods.supplier_code, goods.price]).to eq ['0001', '111', 10.25]
    end

    it "should create none after adding not valid sku" do
      goods = FactoryGirl.build(:goods, sku: '')

      expect(goods).to be_invalid
      expect(goods.errors[:sku]).to include("can't be blank")
    end

    it "should create none after adding not valid supplier_code" do
      goods = FactoryGirl.build(:goods, supplier_code: '')

      expect(goods).to be_invalid
      expect(goods.errors[:supplier_code]).to include("can't be blank")
    end

    it "should create none after adding not unique sku" do
      goods = FactoryGirl.create(:goods)
      goods_twin = FactoryGirl.build(:goods)

      expect(goods_twin).to be_invalid
      expect(goods_twin.errors[:sku]).to include("has already been taken")
    end
  end

  it "should have sku index for quick search" do
    expect(Supplier.connection.indexes(:goods).map(&:columns)).to include(["sku"])
  end
end