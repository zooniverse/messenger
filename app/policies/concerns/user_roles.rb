module UserRoles
  extend ActiveSupport::Concern

  def privileged_project_ids
    return [] unless user
    @privileged_project_ids ||= user.roles.select do |id, roles|
      (roles & %w(owner collaborator)).any?
    end.keys
  end
end
