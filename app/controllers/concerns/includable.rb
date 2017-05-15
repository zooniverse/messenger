module Includable
  extend ActiveSupport::Concern

  def includes
    params.fetch :include, serializer_class.default_includes
  end
end
