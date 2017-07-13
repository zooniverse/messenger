class TranscriptionPolicy < ApplicationPolicy
  delegate :admin_or_authorized?, to: :project_policy

  def create?
    admin_or_authorized?
  end

  def update?
    admin_or_authorized?
  end

  def destroy?
    admin_or_authorized?
  end

  def project_policy
    ProjectPolicy.new user, projects
  end

  def projects
    records.compact.collect(&:project).uniq.compact
  end

  class Scope < Scope
    def resolve
      privileged_policy_scope
    end
  end
end
