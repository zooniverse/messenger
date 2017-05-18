class TranscriptionsController < ApplicationController
  self.resource = Transcription
  self.serializer_class = TranscriptionSerializer
  self.schema_class = TranscriptionSchema

  before_action :set_roles
end