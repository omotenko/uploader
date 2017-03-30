class UploaderJob < ActiveJob::Base
  queue_as :default

  def perform(options = {})
    upload = Upload.find(options[:upload_id])

    CsvUploader::Strategy.execute(file_path: upload.attachment.path, file_name: upload.attachment_file_name)
  end
end
