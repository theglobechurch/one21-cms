class StudyDecorator < Draper::Decorator
  delegate_all

  def bibleRefText
    return if object.passage_ref == ""
    passageRef = MultiJson.load(object.passage_ref, :symbolize_keys => true)
    "#{passageRef[:reference_book]} #{passageRef[:reference_book_start_ch]}:#{passageRef[:reference_book_start_v]}–#{passageRef[:reference_book_end_ch]}:#{passageRef[:reference_book_end_v]}"
  end
end
