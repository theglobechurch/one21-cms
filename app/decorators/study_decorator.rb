class StudyDecorator < Draper::Decorator
  delegate_all

  def bibleRefText
    return if object.passage_ref.blank?

    passageRef = MultiJson.load(object.passage_ref, :symbolize_keys => true)

    refString = ""
    passageRef.each_with_index do |r, key|
      refString += ", " if key != 0
      refString += "#{r[:reference_book]} #{r[:reference_book_start_ch]}:#{r[:reference_book_start_v]}–#{r[:reference_book_end_ch]}:#{r[:reference_book_end_v]}"
    end
    refString
  end
end
