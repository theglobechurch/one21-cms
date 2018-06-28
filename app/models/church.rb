class Church < ApplicationRecord

  has_many :users
  has_many :church_guides
  has_many :guides, through: :church_guides
  has_many :graphics

  validates :church_name, :email, :url, :city, :slug, presence: true
  validates :email, :slug,  uniqueness: true
  validates :url, :phone, uniqueness: true, allow_blank: true

  acts_as_url :church_name, sync_url: true, force_downcase: true, url_attribute: :slug, only_when_blank: true

  default_scope { order("church_name asc") }
  scope :verified, -> { where(verified: true) }

  def to_param
    slug
  end

  def self.find_by_slug(s)
    find_by slug: s
  end

end
