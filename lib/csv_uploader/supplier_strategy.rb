module CsvUploader
  class SupplierStrategy

    def self.execute(file_path:)
      Supplier.connection.execute <<-SQL
        DROP TABLE IF EXISTS supplier_imports;
        CREATE TEMP TABLE supplier_imports
        (
          code character varying,
          name character varying
        )
      SQL

      File.open(file_path, 'r') do |file|
        Supplier.connection.raw_connection.copy_data %{copy supplier_imports from stdin with csv delimiter ','} do
          while line = file.gets do
            line = line.gsub('¦', ',')

            Supplier.connection.raw_connection.put_copy_data(line)
          end
        end
      end

      Supplier.connection.execute <<-SQL
        insert into suppliers(code, name, created_at, updated_at)
        select code, name, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
        from supplier_imports
        on conflict(code) do
        update set
          code = EXCLUDED.code,
          name = EXCLUDED.name,
          created_at = EXCLUDED.created_at,
          updated_at = EXCLUDED.updated_at
      SQL
    end
  end
end