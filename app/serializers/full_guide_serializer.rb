class FullGuideSerializer < ActiveModel::Serializer
  
  attributes :guide_name, :slug, :teaser, :description, :copyright, :highlight_first

  has_many :studies

  def description
    object.description.gsub! "\r\n\r\n", "\r\n"
    object.description.split("\r\n")
  end
end
