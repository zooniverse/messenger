class TranscriptionSerializer < ApplicationSerializer
  attributes :id, :status, :text
  filterable_by :project_id, :status
  link(:self){ transcription_path object }
end
