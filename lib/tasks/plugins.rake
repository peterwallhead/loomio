namespace :plugins do
  task :install => :environment do
    require [Rails.root, :plugins, :base].join('/')
    require [Rails.root, :plugins, :fetcher].join('/')
    require [Rails.root, :plugins, :repository].join('/')
    Plugins::Repository.acquire_plugins!
    Plugins::Repository.install_plugins!
  end
end
