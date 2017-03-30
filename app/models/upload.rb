class Upload < ApplicationRecord
  SUPPLIER_CSV_FILE = 'suppliers.csv'
  GOODS_CSV_FILE = 'sku.csv'

  has_attached_file :attachment
  validates_attachment_content_type :attachment, content_type: ['text/csv']
  validates_attachment_file_name :attachment, matches: [SUPPLIER_CSV_FILE, GOODS_CSV_FILE]
end
