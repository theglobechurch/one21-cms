class Church < ApplicationRecord

  has_many :users,
           inverse_of: :church,
           dependent: :nullify
  has_many :church_guides,
           dependent: :nullify
  has_many :guides,
           through: :church_guides
  has_many :graphics,
           dependent: :nullify

  belongs_to :graphic,
             foreign_key: :graphics_id,
             optional: true,
             inverse_of: :church

  after_create :post_setup if User.current

  validates :church_name, :email, :url, :city, :slug, presence: true
  validates :email, :slug, uniqueness: true
  validates :url, :phone, uniqueness: true, allow_blank: true

  acts_as_url :church_name,
              sync_url: true,
              force_downcase: true,
              url_attribute: :slug,
              only_when_blank: true

  default_scope { order("church_name asc") }
  scope :verified, -> { where(verified: true) }

  def to_param
    slug
  end

private

  def post_setup
    # Link with current user
    u = User.current
    u.churches_id = id
    u.save

    # Create guide
    Guide.
      unscoped.
      create(guide_name: 'Sermons',
             teaser: "Sermons from #{church_name}",
             highlight_first: true,
             sorting: 'date_desc')
  end

end
