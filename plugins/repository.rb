module Plugins
  class Repository
    class PluginNotFoundError < Exception; end

    def self.install_plugins!
      Dir.glob('plugins/*/plugin.rb').each { |plugin_file| require [Rails.root, plugin_file].join('/') }
      repository.keys.each { |name| install! name }
    end

    def self.store(plugin)
      repository[plugin.name] = plugin
    end

    def self.install!(name)
      raise PluginNotFoundError.new unless plugin = repository[name]
      return unless plugin.enabled || plugin.installed

      plugin.actions.map(&:call)
      plugin.outlets.map { |outlet| apply_outlet(outlet, plugin.name) }
      plugin.events.map  { |events| events.call(EventBus) }
      plugin.installed = true
    end

    def self.translations_for(locale = I18n.locale)
      active_plugins.map(&:translations).reduce({}, :merge).slice(locale.to_s)
    end

    def self.to_config
      {
        installed: active_plugins,
        activeOutlets: active_outlets
      }
    end

    def self.apply_outlet(outlet, name)
      raise "Error installing #{name}: Outlet #{outlet} is already being used by #{active_outlets[outlet]}" if active_outlets[outlet]
      active_outlets[outlet] = name
    end

    def self.active_plugins
      repository.values.select(&:installed)
    end

    def self.active_outlets
      @@active_outlets ||= Hash.new
    end
    private_class_method :active_outlets

    def self.repository
      @@repository ||= Hash.new
    end
    private_class_method :repository

  end
end
