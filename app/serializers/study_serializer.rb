class StudySerializer < ActiveModel::Serializer
  attributes :study_name, :slug, :description, :recording_url, :website_url, :passage_ref, :questions, :status
end
