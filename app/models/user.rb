class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:user, :churchuser, :churchadmin, :superadmin]
  after_initialize :set_default_role, :if => :new_record?

  belongs_to :church,
             optional: true,
             foreign_key: :churches_id

  validates :first_name, :family_name, presence: true

  def set_default_role
    self.role ||= :churchadmin
  end

end
