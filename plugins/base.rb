class Loomio::Plugins::Base

  def self.plugin_name(name)
    @@plugin_name = name
  end

  def self.register_classes
    Array(yield) { |klass| puts klass }
  end

  def self.register_assets
    Array(yield) { |asset| puts asset }
  end

  def self.register_migrations
    Array(yield) { |migration| puts migration}
  end

  def self.register_events
    yield EventBus
  end
end
