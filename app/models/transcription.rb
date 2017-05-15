class Transcription < ApplicationRecord
  belongs_to :project
  validates :status, inclusion: {
    in: %w(accepted rejected amended unreviewed),
    message: 'is not a valid status'
  }
  scope :accepted, ->{ where status: 'accepted' }
  scope :rejected, ->{ where status: 'rejected' }
  scope :amended, ->{ where status: 'amended' }
  scope :unreviewed, ->{ where status: 'unreviewed' }
end
