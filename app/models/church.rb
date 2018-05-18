class Church < ApplicationRecord

  has_many :users

  validates :church_name, :email, :url, :city, :slug, presence: true
  validates :email, :slug, :phone, :url, uniqueness: true

  acts_as_url :church_name, sync_url: true, force_downcase: true, url_attribute: :slug, only_when_blank: true

  def to_param
    slug
  end

  def self.find_by_slug(s)
    find_by slug: s
  end

end
