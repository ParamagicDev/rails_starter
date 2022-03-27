class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable,
    :recoverable, :rememberable, :validatable

  # has_many :organization_memberships
  # has_many :organizations, through: :organization_memberships
end
