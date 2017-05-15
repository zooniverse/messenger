module Filterable
  extend ActiveSupport::Concern

  def filter(scope)
    allowed_filter_params.each_pair do |key, value|
      scope = scope.where key => value
    end
    scope
  end

  def allowed_filter_params
    filter_params.slice *serializer_class.filterable_attributes
  end

  def filter_params
    params.fetch :filter, { }
  end
end
