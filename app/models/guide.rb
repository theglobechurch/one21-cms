class Guide < ApplicationRecord

  has_many :studies,
           foreign_key: "guides_id",
           inverse_of: :guide,
           dependent: :destroy
  has_many :church_guides,
           dependent: :nullify
  has_many :churches,
           through: :church_guides

  belongs_to :graphic,
             foreign_key: :graphics_id,
             optional: true,
             inverse_of: :guides

  validates :guide_name, :slug, presence: true

  acts_as_url :guide_name,
              sync_url: true,
              force_downcase: true,
              url_attribute: :slug,
              only_when_blank: true,
              allow_duplicates: true

  enum status:  %i[draft published archived deleted]
  enum sorting: %i[date_desc date_asc ordered]
  after_initialize :set_default_status, if: :new_record?

  accepts_nested_attributes_for :church_guides

  scope :not_deleted, -> { where.not(status: 'deleted') }

  def to_param
    slug
  end

  def self.find_by_slug(guide_slug)
    find_by slug: guide_slug
  end

private

  def set_default_status
    self.status ||= :draft
  end

end
