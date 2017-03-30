require "rails_helper"

RSpec.describe "Strategy management" do

  context "with strategy according file_name" do
    let(:suppliers_path) { File.join(Rails.root, 'spec/lib/csv_uploader/files/suppliers.csv') }
    let(:goods_path)     { File.join(Rails.root, 'spec/lib/csv_uploader/files/sku.csv') }

    it "should save 5 records from suppliers.csv" do
      CsvUploader::Strategy.run(file_path: suppliers_path, file_name: 'suppliers.csv')
      expect(Supplier.count).to eq 5
    end

    context "with sku.csv" do

      it "shouldn't save records before if suppliers not exist" do
        begin
          CsvUploader::Strategy.run(file_path: goods_path, file_name: 'sku.csv')
        rescue ActiveRecord::InvalidForeignKey => e
          expect(e.message).to include('PG::ForeignKeyViolation')
        end
      end

      it "should save 5 records" do
        CsvUploader::Strategy.run(file_path: suppliers_path, file_name: 'suppliers.csv')
        CsvUploader::Strategy.run(file_path: goods_path, file_name: 'sku.csv')

        expect(Supplier.count).to eq 5
        expect(Goods.count).to eq 5
        expect(Goods.first.supplier.code).to eq Goods.first.supplier_code
      end
    end
  end
end