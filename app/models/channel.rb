class Channel < ApplicationRecord
  belongs_to :user
  belongs_to :team
  validates_presence_of :slug
end
