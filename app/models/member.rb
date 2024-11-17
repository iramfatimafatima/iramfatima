class Member < ApplicationRecord
  belongs_to :team
  belongs_to :user

  # validates :first_name, :last_name, :email, presence: true
  # validates :email, uniqueness: { scope: :team_id }
end
