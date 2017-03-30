module CsvUploader
  class GoodsStrategy

    def self.execute(file_path:)
      Goods.connection.execute <<-SQL
        DROP TABLE IF EXISTS goods_imports;
        CREATE TEMP TABLE goods_imports
        (
          sku character varying,
          supplier_code character varying,
          af_1 character varying,
          af_2 character varying,
          af_3 character varying,
          af_4 character varying,
          af_5 character varying,
          af_6 character varying,
          price float
        )
      SQL

      File.open(file_path, 'r') do |file|
        Goods.connection.raw_connection.copy_data %{copy goods_imports from stdin with csv delimiter ','} do
          while line = file.gets do
            line = line.gsub('¦', ',')

            Goods.connection.raw_connection.put_copy_data(line)
          end
        end
      end

      Goods.connection.execute <<-SQL
        insert into goods(sku, supplier_code, af_1, af_2, af_3, af_4, af_5, af_6, price, created_at, updated_at)
        select sku, supplier_code, af_1, af_2, af_3, af_4, af_5, af_6, price, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
        from goods_imports
        on conflict(sku) do
        update set
          supplier_code = EXCLUDED.supplier_code,
          af_1 = EXCLUDED.af_1,
          af_2 = EXCLUDED.af_2,
          af_3 = EXCLUDED.af_3,
          af_4 = EXCLUDED.af_4,
          af_5 = EXCLUDED.af_5,
          af_6 = EXCLUDED.af_6,
          price = EXCLUDED.price,
          created_at = EXCLUDED.created_at,
          updated_at = EXCLUDED.updated_at
      SQL
    end
  end
end