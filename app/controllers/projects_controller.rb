class ProjectsController < ApplicationController
  self.resource = Project
  self.serializer_class = ProjectSerializer
  self.schema_class = ProjectSchema
  before_action :set_roles, only: :create
  before_action :set_project_id, only: :create

  def set_project_id
    slug = service.attributes[:slug]
    return unless slug
    project = panoptes_client.project slug
    service.attributes[:id] = project[:id]
  end
end