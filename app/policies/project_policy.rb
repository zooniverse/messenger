class ProjectPolicy < ApplicationPolicy
  def create?
    admin_or_authorized?
  end

  def admin_or_authorized?
    admin? || authorized?
  end

  def authorized?
    return false if records.empty?
    records.compact.all? do |record|
      privileged_project_ids.include? record.id
    end
  end
end
