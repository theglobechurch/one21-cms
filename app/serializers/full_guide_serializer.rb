class FullGuideSerializer < ActiveModel::Serializer
  
  attributes :guide_name, :slug, :teaser, :description, :copyright, :highlight_first

  has_many :studies
end
