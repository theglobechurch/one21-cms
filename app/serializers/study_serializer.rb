class StudySerializer < ActiveModel::Serializer
  
  attributes :study_name, :slug, :description, :sort_order, :recording_url, :website_url, :passage_ref, :questions
end
