class Team < ApplicationRecord
  belongs_to :user
  has_many :users, through: :team_users
  has_many :team_users
  validates_presence_of :slug, :user
end
