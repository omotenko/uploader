class Goods < ApplicationRecord
  self.table_name = 'goods'

  scope :with_suppliers, -> { joins('INNER JOIN suppliers ON suppliers.code = goods.supplier_code') }

  belongs_to :supplier, foreign_key: :supplier_code, primary_key: :code

  validates :sku, presence: true, uniqueness: true
  validates :supplier_code, presence: true
end
