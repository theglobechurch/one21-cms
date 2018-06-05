class Guide < ApplicationRecord

  has_many :studies, foreign_key: "guides_id"
  has_many :church_guides
  has_many :churches, through: :church_guides

  validates :guide_name, :slug, presence: true
  validates :slug,  uniqueness: true

  acts_as_url :guide_name, sync_url: true, force_downcase: true, url_attribute: :slug, only_when_blank: true

  enum status: [:draft, :published, :archived, :deleted]
  after_initialize :set_default_status, :if => :new_record?

  after_create :link_church

  def to_param
    slug
  end

  def self.find_by_slug(s)
    find_by slug: s
  end

private

  def link_church()
    ChurchGuide.create([{
      church_id: User.current.church.id,
      guide_id: self.id,
      promoted: false,
      owner: true
    }])
  end

  def set_default_status
    self.status ||= :draft
  end

end
