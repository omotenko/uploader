class UploadsController < ApplicationController

  def new
    @upload = Upload.new
  end

  def create
    begin
      @upload = Upload.new(upload_params)
    rescue ActionController::ParameterMissing
      flash[:error] = "Couldn't find attachment."
      return redirect_to(new_upload_url)
    end

    if @upload.save
      UploaderJob.perform_later(upload_id: @upload.id)
      return redirect_to(goods_url)
    else
      flash[:error] = "Couldn't save file."
      return redirect_to(new_upload_url)
    end
  end

  private

  def upload_params
    params.require(:upload)
          .permit(:attachment)
  end
end
