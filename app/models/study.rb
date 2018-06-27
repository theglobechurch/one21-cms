class Study < ApplicationRecord

  belongs_to :guide, foreign_key: "guides_id"

  validates :study_name, :slug, :questions, presence: true
  validates :slug, uniqueness: true
  validates :sort_order, numericality: { only_integer: true }

  acts_as_url :study_name, sync_url: true, force_downcase: true, url_attribute: :slug, only_when_blank: true

  enum status: [:draft, :published, :archived, :deleted]
  after_initialize :set_default_status, :if => :new_record?

  default_scope { where status: 'published' }

  def to_param
    slug
  end

  def self.find_by_slug(s)
    find_by slug: s
  end

private

  def set_default_status
    self.status ||= :draft
  end

end
