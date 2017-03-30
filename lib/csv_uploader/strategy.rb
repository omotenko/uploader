module CsvUploader
  class Strategy

    class FileNotFould < StandardError; end
    class FileIncompatible < StandardError; end

    def self.execute(file_path:, file_name:)

      raise FileNotFould, file_name unless File.exist?(file_path)

      if file_name == Upload::SUPPLIER_CSV_FILE
        SupplierStrategy.execute(file_path: file_path)
      elsif file_name == Upload::GOODS_CSV_FILE
        GoodsStrategy.execute(file_path: file_path)
      else
        raise FileIncompatible, file_name
      end
    end
  end
end