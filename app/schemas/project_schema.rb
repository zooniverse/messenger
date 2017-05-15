class ProjectSchema < ApplicationSchema
  def create
    root do |root_object|
      id :id, required: true
      string :slug, required: true
      additional_properties false
    end
  end
end
