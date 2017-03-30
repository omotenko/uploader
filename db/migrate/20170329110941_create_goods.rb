class CreateGoods < ActiveRecord::Migration[5.0]
  def change
    create_table :goods do |t|
      t.string :sku
      t.string :supplier_code
      t.string :af_1
      t.string :af_2
      t.string :af_3
      t.string :af_4
      t.string :af_5
      t.string :af_6
      t.float :price

      t.index :sku, unique: true
      t.timestamps
    end

    add_foreign_key :goods, :suppliers, column: :supplier_code, primary_key: :code
  end
end
