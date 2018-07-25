class ChurchSerializer < ActiveModel::Serializer

  # TODO: include church logo of some form here…
  attributes :name, :slug

  def name
    object.church_name
  end

end
