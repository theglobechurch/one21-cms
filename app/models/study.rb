class Study < ApplicationRecord

  belongs_to :guide,
             foreign_key: :guides_id,
             inverse_of: :studies
  belongs_to :graphic,
             foreign_key: :graphics_id,
             optional: true,
             inverse_of: :studies

  validates :study_name, :slug, :questions_json, presence: true
  validates :slug, uniqueness: true
  validates :sort_order, numericality: {only_integer: true}

  acts_as_url :study_name,
              sync_url: true,
              force_downcase: true,
              url_attribute: :slug,
              only_when_blank: true

  enum status: %i[draft published archived deleted]
  after_initialize :set_default_status, if: :new_record?

  before_save :set_publish_date

  def to_param
    slug
  end

  def questions
    @questions ||= if questions_json.present?
                     MultiJson.load(
                       questions_json,
                       symbolize_keys: true
                     )
                   else
                     []
                   end
  end

  def passage_ref
    @passage_ref ||= if passage_ref_json.present?
                       p = MultiJson.load(
                         passage_ref_json,
                         symbolize_keys: true
                       )
                       p.each do |n|
                         n.delete(:passage)
                       end
                     else
                       []
                     end
  end

  def scripture
    @scripture ||= if passage_ref_json.present?
                     p = MultiJson.load(
                       passage_ref_json,
                       symbolize_keys: true
                     )
                     p.map do |n|
                       n[:passage][:esv] if n[:passage] && n[:passage][:esv]
                     end
                   else
                     []
                   end
  end

  def passage_str
    return if passage_ref.blank?

    ref_string = ""
    passage_ref.each_with_index do |r, key|
      ref_string += ", " if key != 0
      ref_string += "#{r[:reference_book]} #{r[:reference_book_start_ch]}:#{r[:reference_book_start_v]}–#{r[:reference_book_end_ch]}:#{r[:reference_book_end_v]}"
    end
    ref_string
  end

  def state
    if status == "published" && published_at && published_at.future?
      "scheduled"
    else
      status
    end
  end

  def lead_image
    if graphic
      graphic.graphic_urls
    end
  end

  def lead_image_thumbnails
    if graphic
      graphic.graphic_thumbnail_urls
    elsif guide.graphic
      guide.graphic.graphic_thumbnail_urls
    end
  end

private

  def set_default_status
    self.status ||= :draft
  end

  def set_publish_date
    if status == 'published' && published_at.nil?
      self.published_at = Time.current
    end

    if status == 'draft'
      self.published_at = nil
    end
  end

end
