class Team < ApplicationRecord
  belongs_to :user
  validates_presence_of :slug, :user
end
