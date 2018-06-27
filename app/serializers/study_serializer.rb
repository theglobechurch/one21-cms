class StudySerializer < ActiveModel::Serializer
  attributes :name, :slug, :description, :recording_url, :website_url, :passage_ref, :passage, :questions

  def name
    object.study_name
  end

  def passage
    object.passage_str
  end
end
