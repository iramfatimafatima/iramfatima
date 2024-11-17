class User < ApplicationRecord
  
  has_many :owned_teams, class_name: 'Team', foreign_key: 'owner_id', dependent: :destroy
  has_many :memberships, class_name: 'Member', dependent: :destroy
  has_many :teams, through: :memberships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
