module CsvUploader
  class Strategy

    class FileNotFould < StandardError; end
    class FileIncompatible < StandardError; end

    attr_reader :file_path

    def initialize(file_path:)
      @file_path = file_path
    end

    def execute
      create_tmp_table
      copy_file_to_tmp_table
      upsert
    end

    def self.run(file_path:, file_name:)
      
      raise FileNotFould, file_name unless File.exist?(file_path)

      if file_name == Upload::SUPPLIER_CSV_FILE
        SupplierStrategy.new(file_path: file_path).execute
      elsif file_name == Upload::GOODS_CSV_FILE
        GoodsStrategy.new(file_path: file_path).execute
      else
        raise FileIncompatible, file_name
      end
    end

    protected

    def create_tmp_table
      raise 'Not Implemented'
    end

    def copy_file_to_tmp_table(table_name)
      File.open(file_path, 'r') do |file|
        ActiveRecord::Base.connection.raw_connection.copy_data %{copy #{table_name} from stdin with csv delimiter ','} do
          while line = file.gets do
            line = line.gsub('¦', ',')

            ActiveRecord::Base.connection.raw_connection.put_copy_data(line)
          end
        end
      end
    end

    def upsert
      raise 'Not Implemented'
    end
  end
end