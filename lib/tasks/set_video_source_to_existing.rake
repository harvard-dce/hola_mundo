namespace :hola_mundo do
  desc 'Set camera videos to have an existing source'
  task set_to_existing: :environment do
    Video.where(source: 'camera').update_all(source: 'existing')
  end
end
