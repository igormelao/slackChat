class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :name, :password
  has_many :teams
  has_many :team_users, dependent: :destroy
  has_many :member_teams, through: :team_users, :source => :team

  def my_teams
    self.teams  + self.member_teams
  end
end
