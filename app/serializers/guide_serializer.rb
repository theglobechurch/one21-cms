class GuideSerializer < ActiveModel::Serializer

  attributes :name, :slug, :teaser, :description, :copyright, :highlight_first

  def name
    object.guide_name
  end

end
