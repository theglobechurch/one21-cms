module StatusHelper
  def status_change_button(name, record, status, options = {},
                          html_options = {})
    model_name = record.class.name.underscore
    button_to name,
              record,
              method: :patch,
              params: {
                :"#{model_name}[status]" => status
              },
              **html_options
  end
end
