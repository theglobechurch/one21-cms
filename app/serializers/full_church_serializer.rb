class FullChurchSerializer < ActiveModel::Serializer

  # TODO: include church logo of some form here…
  attributes :name, :slug, :email, :url

  def name
    object.church_name
  end

end
