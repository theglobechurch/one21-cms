class ChurchSerializer < ActiveModel::Serializer

  # TODO: include church logo of some form here…
  attributes :name, :slug
  attribute :logo, if: :logo?
  attribute :logo_sq, if: :logo?

  def name
    object.church_name
  end

  def logo?
    true if object.church_logo_sq
  end

  def logo_sq
    "#{base_url}#{object.church_logo_sq_250.try(:remote_url)}"
  end

  def logo
    "#{base_url}#{object.church_logo_600.try(:remote_url)}"
  end

  def base_url
    @instance_options[:params][:base_url] if @instance_options[:params]
  end

end
