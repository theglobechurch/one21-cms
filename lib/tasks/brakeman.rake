require 'brakeman'

namespace :brakeman do
  desc "Check your code with Brakeman"
  task :check do
    result = Brakeman.run app_path: '.', print_report: true,
                          ignore_file: 'config/brakeman.ignore'
    # exit Brakeman::Warnings_Found_Exit_Code \
    #   unless result.filtered_warnings.empty?
  end
end
