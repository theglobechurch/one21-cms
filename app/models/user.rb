class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable

  default_scope { order(family_name: :asc) }

  enum role: %i[user churchuser churchadmin superadmin]
  after_initialize :set_default_role, if: :new_record?

  belongs_to :church,
             optional: true,
             foreign_key: :churches_id,
             inverse_of: :users

  validates :email, :first_name, :family_name, presence: true

  def full_name
    "#{first_name} #{family_name}"
  end

  def set_default_role
    self.role ||= :churchadmin
  end

  def self.current=(user)
    Thread.current[:current_user] = user
  end

  def self.current
    Thread.current[:current_user]
  end

end
