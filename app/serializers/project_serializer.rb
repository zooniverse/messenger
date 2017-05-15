class ProjectSerializer < ApplicationSerializer
  attributes :id, :slug
  filterable_by :slug
  link(:self){ project_path object }
end
