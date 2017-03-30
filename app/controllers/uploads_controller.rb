class UploadsController < ApplicationController

  def new
    @upload = Upload.new
  end

  def create
    @upload = Upload.new(upload_params)
    if @upload.save
      UploaderJob.perform_later(upload_id: @upload.id)
      return redirect_to(goods_url)
    else
      errors = @upload.errors.messages
      raise "Couldn't save file with errors #{errors}"
    end
  end

  private

  def upload_params
    params.require(:upload)
          .permit(:attachment)
  end
end
