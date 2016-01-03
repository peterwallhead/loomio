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
      plugin.events.map { |events| events.call(EventBus) }
      plugin.outlets.map { |outlet| active_outlets.add(outlet) }
      plugin.installed = true
    end

    def self.to_config
      {
        installed:      repository.values.select(&:installed),
        active_outlets: active_outlets.map(&:to_s).map(&:camelcase)
      }
    end

    def self.active_outlets
      @@active_outlets ||= Set.new
    end
    private_class_method :active_outlets

    def self.repository
      @@repository ||= Hash.new
    end
    private_class_method :repository

  end
end
