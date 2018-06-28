class Study < ApplicationRecord

  belongs_to :guide,
             foreign_key: :guides_id
  belongs_to :graphic,
             foreign_key: :graphics_id

  validates :study_name, :slug, :questions_json, presence: true
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

  def questions
    @questions ||= if questions_json.present?
                     MultiJson.load(questions_json, symbolize_keys: true)
                   else
                     []
                   end
  end

  def passage_ref
    @passage_ref ||= if passage_ref_json.present?
                       MultiJson.load(passage_ref_json, symbolize_keys: true)
                     else
                       []
                     end
  end

  def passage_str
    return if passage_ref.blank?

    refString = ""
    passage_ref.each_with_index do |r, key|
      refString += ", " if key != 0
      refString += "#{r[:reference_book]} #{r[:reference_book_start_ch]}:#{r[:reference_book_start_v]}–#{r[:reference_book_end_ch]}:#{r[:reference_book_end_v]}"
    end
    refString
  end

private

  def set_default_status
    self.status ||= :draft
  end

end
