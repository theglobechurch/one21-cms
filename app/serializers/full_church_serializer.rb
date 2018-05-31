class FullChurchSerializer < ActiveModel::Serializer
  
  # ToDo: include church logo of some form here…
  attributes :church_name, :slug, :email, :url

end
