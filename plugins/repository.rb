module Plugins
  class Repository
    class PluginNotFoundError < Exception; end

    def self.install_plugins!
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
      plugin.installed = true
    end

    def self.repository
      @@repository ||= Hash.new
    end
    private_class_method :repository

  end
end
