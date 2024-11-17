class Team < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :members, dependent: :destroy
  has_many :users, through: :members
  
  validates :name, presence: true
end
