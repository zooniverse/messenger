class Project < ApplicationRecord
  has_many :transcriptions

  validates :slug, presence: true
end
