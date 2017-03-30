module CsvUploader
  class SupplierStrategy < Strategy

    protected

    def create_tmp_table
      Supplier.connection.execute <<-SQL
        DROP TABLE IF EXISTS supplier_imports;
        CREATE TEMP TABLE supplier_imports
        (
          code character varying,
          name character varying
        )
      SQL
    end

    def copy_file_to_tmp_table
      super('supplier_imports')
    end

    def upsert
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