module Paginatable
  extend ActiveSupport::Concern

  def paginate(scope)
    scope.page(page).per page_size
  end

  def page
    params.dig(:page, :number) || 1
  end

  def page_size
    params.dig(:page, :size) || 10
  end
end
