namespace :brakeman do

  desc "Run Brakeman"
  task :run do |t, args|
    require 'brakeman'

    tracker = Brakeman.run :app_path => "."
    if tracker.warnings.present? || tracker.errors.present?
      puts tracker.report
      exit 1
    else
      puts 'brakeman reports no errors or warnings'
    end
  end
end
