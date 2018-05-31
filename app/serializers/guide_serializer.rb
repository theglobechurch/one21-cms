class GuideSerializer < ActiveModel::Serializer
  
  attributes :guide_name, :slug, :teaser, :description, :copyright, :highlight_first

end
