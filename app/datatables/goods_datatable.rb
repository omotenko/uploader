class GoodsDatatable
  delegate :params, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Goods.count,
      iTotalDisplayRecords: goods.total_entries,
      aaData: data
    }
  end

private

  def data
    goods.map do |item|
      [
        item.sku,
        item.price,
        item.af_1,
        item.af_2,
        item.af_3,
        item.af_4,
        item.af_5,
        item.af_6,
        item.supplier.code,
        item.supplier.name
      ]
    end
  end

  def goods
    @goods ||= fetch_goods
  end

  def fetch_goods
    goods = Goods.with_suppliers
    goods = goods.page(page).per_page(per_page)
    if params[:sSearch].present?
      goods = goods.where("goods.sku like :search or suppliers.code like :search or suppliers.name like :search", search: "%#{params[:sSearch]}%")
    end
    goods
  end

  def page
    params[:iDisplayStart].to_i / per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end
end