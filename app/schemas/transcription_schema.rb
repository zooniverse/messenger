class TranscriptionSchema < ApplicationSchema
  def create
    changes required: true
  end

  def update
    changes
  end

  def changes(required = { })
    root do |root_object|
      id :id, **required
      id :project_id, **required
      string :text, **required

      root_object.entity :status, **required do
        enum %w(accepted rejected amended unreviewed)
      end
      additional_properties false
    end
  end
end
