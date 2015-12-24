require [Rails.root, :plugins, :repository].join('/')
require [Rails.root, :plugins, :base].join('/')
Plugins::Repository.install_plugins!
