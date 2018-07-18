class FullChurchSerializer < ActiveModel::Serializer

  # TODO: include church logo of some form here…
  attributes :church_name, :slug, :email, :url

end
