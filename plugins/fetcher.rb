module Plugins
  Fetcher = Struct.new(:repo, :version, :force) do

    def execute!
      should_execute? && fetch && checkout
      load_code
    rescue => e
      clean && puts("WARNING: Unable to clone #{repo} at #{version}: #{e.message}")
    end

    private

    def should_execute?
      clean if force
      puts "#{folder} alreadys exists in this repository" if already_there = File.directory?(folder)
      !already_there
    end

    def clean
      SafeShell.execute "rm", "-rf", folder
    end

    def fetch
      SafeShell.execute "git", "clone", "https://#{ENV['GITHUB_USERNAME']}:#{ENV['GITHUB_PASSWORD']}@github.com/#{repo}.git"
    end

    def checkout
      Dir.chdir(folder) { SafeShell.execute "git", "checkout", version || "master" }
    end

    def load_code
      load "./#{folder}/plugin.rb"
    end

    def folder
      @folder ||= repo.split('/').last
    end
  end
end