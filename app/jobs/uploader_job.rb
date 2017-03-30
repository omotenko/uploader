class UploaderJob < ActiveJob::Base
  queue_as :default

  rescue_from(CsvUploader::Strategy::FileNotFould, CsvUploader::Strategy::FileIncompatible) do |exception|
    logger.error(exception)
  end

  def perform(options = {})
    upload = Upload.find(options[:upload_id])

    CsvUploader::Strategy.run(file_path: upload.attachment.path, file_name: upload.attachment_file_name)
  end
end
