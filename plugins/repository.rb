module Plugins
  class Repository

    def self.acquire_plugins!
      Dir.chdir('plugins') do
        YAML.load_file([Rails.root, :config, :"plugins.yml"].join('/'))['plugins'].each do |plugin|
          Fetcher.new(plugin[1]['repo'], plugin[1]['version']).execute
        end
        Dir.glob('*/plugin.rb').each { |plugin_file| require [Rails.root, plugin_file].join('/') }
      end
    end

    def self.install!(name)
      return unless plugin = instance_for(name)

      plugin.actions.map(&:call)
      plugin.outlets.map { |outlet| apply_outlet(outlet) }
      plugin.events.map  { |events| events.call(EventBus) }
      repository[name] = plugin
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

    def self.instance_for(name)
      "#{name.camelize}::Plugin".constantize.setup!
    rescue => e
      puts "Unable to install plugin #{name}: #{e.message}"
    end
    private_class_method :instance_for

    def self.apply_outlet(outlet)
      active_outlets[outlet.outlet_name] = active_outlets[outlet.outlet_name] << outlet
    end
    private_class_method :apply_outlet

    def self.active_plugins
      repository.values.select(&:installed)
    end
    private_class_method :active_plugins

    def self.active_outlets
      @@active_outlets ||= Hash.new { [] }
    end
    private_class_method :active_outlets

    def self.repository
      @@repository ||= Hash.new
    end
    private_class_method :repository

  end
end
