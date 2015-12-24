require "#{Rails.root}/plugins/repository"

module Plugins
  class NoCodeSpecifiedError < Exception; end

  class Base
    attr_accessor :name, :installed
    attr_reader :actions, :events, :enabled

    def self.setup!(name)
      Repository.store new(name).tap { |plugin| yield plugin }
    end

    def initialize(name)
      @name = name
      @actions, @events = Set.new, Set.new
    end

    def enabled=(value)
      @enabled = value.is_a?(TrueClass) || ENV[value]
    end

    def use_class_directory(glob)
      use_directory(glob) { |path| use_class(path) }
    end

    def use_class(path = nil, &block)
      raise NoCodeSpecifiedError.new unless block_given? || path
      proc = block_given? ? block.to_proc : Proc.new { require [Rails.root, :plugins, @name, path].join('/') }
      @actions.add proc
    end

    def use_asset_directory(glob)
      use_directory(glob) { |path| use_asset(path) }
    end

    def use_asset(path = nil, &block)
      raise NoCodeSpecifiedError.new unless block_given? || path
      # ???
    end
    
    def use_translations(path = nil, &block)
      raise NoCodeSpecifiedError.new unless block_given? || path
      # ???
    end

    def use_migration(path = nil, &block)
      raise NoCodeSpecifiedError.new unless block_given? || path
      # ???
    end

    def use_events(&block)
      raise NoCodeSpecifiedError.new unless block_given?
      @events.add block.to_proc
    end

    private

    def use_directory(glob)
      Dir.chdir("plugins/#{@name}") { Dir.glob("#{glob}/*").each { |path| yield path } }
    end

  end
end
