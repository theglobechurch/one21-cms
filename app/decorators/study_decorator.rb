class StudyDecorator < Draper::Decorator
  delegate_all

  def bible_ref_text
    return if object.passage_ref.blank?

    ref_string = ""
    passage_ref.each_with_index do |r, key|
      ref_string += ", " if key != 0
      ref_string += "#{r[:reference_book]} #{r[:reference_book_start_ch]}:#{r[:reference_book_start_v]}–#{r[:reference_book_end_ch]}:#{r[:reference_book_end_v]}"
    end
    ref_string
  end
end
