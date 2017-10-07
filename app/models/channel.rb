class Channel < ApplicationRecord
  belongs_to :user
  belongs_to :team
  validates_presence_of :slug
  validates :slug, format: { with: /\A[a-zA-Z0-9]+\Z/ }
  validates_uniqueness_of :slug, :scope => :team_id
end
