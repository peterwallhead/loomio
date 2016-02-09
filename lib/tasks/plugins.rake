namespace :plugins do
  task :acquire => :environment do
    require [Rails.root, :plugins, :base].join('/')
    require [Rails.root, :plugins, :fetcher].join('/')
    require [Rails.root, :plugins, :repository].join('/')
    Plugins::Repository.acquire_plugins!
  end
end
