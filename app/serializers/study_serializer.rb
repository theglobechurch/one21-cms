class StudySerializer < ActiveModel::Serializer
  attributes :study_name, :slug, :description, :recording_url, :website_url, :passage_ref, :questions

  def questions
    object.questions.map do |q|
      {
        type: 'question',
        lead: q[:lead],
        followup: q[:followup],
      }
    end
  end
end
