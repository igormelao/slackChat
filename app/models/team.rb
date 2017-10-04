class Team < ApplicationRecord
  belongs_to :user
  has_many :users, through: :team_users
  has_many :team_users, dependent: :destroy
  validates_presence_of :slug, :user

  def my_users
    self.users + [self.user]
  end
end
