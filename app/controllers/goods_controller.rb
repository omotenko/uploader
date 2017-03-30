class GoodsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: GoodsDatatable.new(view_context) }
    end
  end
end
