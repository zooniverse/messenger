class ProjectPolicy < ApplicationPolicy
  def create?
    admin_or_project_owner?
  end

  def admin_or_project_owner?
    admin? || project_owner_or_collaborator?
  end

  def project_owner_or_collaborator?
    return false if records.empty?
    records.compact.all? do |record|
      privileged_project_ids.include? record.id
    end
  end
end
