class ApplicationSerializer < ActiveModel::Serializer
  class << self
    attr_accessor :filterable_attributes, :sortable_attributes, :default_sort, :default_includes
  end

  attribute :id

  def self.filterable_by(*attrs)
    attrs.each do |attr|
      self.filterable_attributes << attr.to_sym
      self.filterable_attributes.uniq!
    end
  end

  def self.sortable_by(*attrs)
    attrs.each do |attr|
      self.sortable_attributes << attr.to_sym
      self.sortable_attributes.uniq!
    end
  end

  def self.default_sort_by(attr)
    self.default_sort = attr.to_sym
  end

  def self.include_by_default(*attrs)
    self.default_includes = attrs.join ','
  end

  def self.inherited(klass)
    klass.filterable_attributes = filterable_attributes&.dup || []
    klass.sortable_attributes = sortable_attributes&.dup || [:id]
    klass.default_sort = default_sort&.dup || :id
    super
  end
end
