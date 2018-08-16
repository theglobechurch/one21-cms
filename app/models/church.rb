class Church < ApplicationRecord
  extend Dragonfly::Model::Validations

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

  after_commit :post_create, on: :create

  validates :church_name, :email, :url, :city, :slug, presence: true
  validates :email, :slug, uniqueness: true
  validates :url, :phone, uniqueness: true, allow_blank: true

  # validates logos are jpg / png / gif

  acts_as_url :church_name,
              sync_url: true,
              force_downcase: true,
              url_attribute: :slug,
              only_when_blank: true

  dragonfly_accessor :church_logo_600
  dragonfly_accessor :church_logo do
    copy_to(:church_logo_sq) unless defined?(:church_logo_sq)

    copy_to(:church_logo_600) do |a|
      a.encode('png', '-quality 70 -interlace plane -resize 600x')
    end
  end

  THUMBSIZES = [500, 250].freeze
  THUMBSIZES.each { |s| dragonfly_accessor :"church_logo_sq_#{s}" }

  dragonfly_accessor :church_logo_sq do
    after_assign do |a|
      if a.width < a.height
        a.thumb!("#{a.width}x#{a.width}#")
      else
        a.thumb!("#{a.height}x#{a.height}#")
      end
    end

    THUMBSIZES.each do |size|
      copy_to(:"church_logo_sq_#{size}") { |a| a.thumb("#{size}x#{size}#") }
    end
  end

  default_scope { order("church_name asc") }
  scope :verified, -> { where(verified: true) }

  def to_param
    slug
  end

private

  def post_create

    u = User.current
    u.update(churches_id: self.id)

    Guide.create(
      guide_name: 'Sermons',
      teaser: "Sermons from #{church_name}",
      highlight_first: true,
      sorting: 'date_desc')
  end

end
