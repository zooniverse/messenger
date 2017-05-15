module Sortable
  extend ActiveSupport::Concern

  def sort(scope)
    if allowed_sort_params.empty?
      scope.order default_sort
    else
      scope.order allowed_sort_params
    end
  end

  def default_sort
    serializer_class.default_sort
  end

  def allowed_sort_params
    return @allowed_sort_params if @allowed_sort_params
    list = sort_params.select do |key, direction|
      key.in? serializer_class.sortable_attributes
    end
    @allowed_sort_params = Hash[*list.flatten]
  end

  def sort_params
    params.fetch(:sort, '').split(',').map do |key|
      direction = key =~ /^\-/ ? :desc : :asc
      [key.sub(/^\-|\+/, '').to_sym, direction]
    end
  end
end
