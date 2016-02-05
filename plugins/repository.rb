module Plugins
  class Repository

    def self.acquire_plugins!
      Dir.chdir('plugins') do
        plugin_directory.each { |plugin| update_plugin!(plugin[1]['repo'], plugin[1]['version']) }
      end
    end

    def self.update_plugin!(repo, version = nil, force: false)
      Fetcher.new(repo, version, force).execute!
    end

    def self.store(plugin)
      repository[plugin.name] = plugin
    end

    def self.install_plugins!
      repository.values.each do |plugin|
        next unless plugin.enabled

        plugin.actions.map(&:call)
        plugin.assets.map  { |asset|  save_asset(asset) }
        plugin.outlets.map { |outlet| active_outlets[outlet.outlet_name] = active_outlets[outlet.outlet_name] << outlet }
        plugin.events.map  { |events| events.call(EventBus) }
        puts "Plugin #{plugin.name} installed!"
        plugin.installed = true
      end
      save_plugin_yaml
    end

    def self.translations_for(locale = I18n.locale)
      active_plugins.map(&:translations).reduce({}, :deep_merge).slice(locale.to_s)
    end

    def self.to_config
      {
        installed:    active_plugins,
        outlets:      active_outlets
      }
    end

    def self.save_asset(asset)
      ext = asset.split('.').last
      plugin_yaml[ext] = Array(plugin_yaml[ext]) | Array(asset)
    end
    private_class_method :save_asset

    def self.active_plugins
      repository.values.select(&:installed)
    end
    private_class_method :active_plugins

    def self.plugin_yaml
      @@plugin_yaml ||= { 'path' => '../plugins' }
    end
    private_class_method :plugin_yaml

    def self.save_plugin_yaml
      File.open([Rails.root, :angular, :build, :config, 'plugins.yml'].join('/'), 'w') { |f| f.write plugin_yaml.to_yaml }
    end
    private_class_method :save_plugin_yaml

    def self.active_outlets
      @@active_outlets ||= Hash.new { [] }
    end
    private_class_method :active_outlets

    def self.repository
      @@repository ||= Hash.new
    end
    private_class_method :repository

    def self.plugin_directory
      @@plugin_directory ||= YAML.load_file([Rails.root, :plugins, :"plugins.yml"].join('/'))['plugins']
    end
    private_class_method :plugin_directory

  end
end
