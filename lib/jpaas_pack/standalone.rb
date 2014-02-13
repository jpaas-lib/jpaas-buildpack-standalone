require "yaml"
require "fileutils"
require "jpaas_pack/procfile"

module JpaasPack
  class Standalone

    def self.use?
      File.exist?("standalone")
    end

    attr_reader :build_path, :cache_path
    
    include JpaasPack::Procfile

    def initialize(build_path, cache_path=nil)
      @build_path = build_path
      @cache_path = cache_path
    end

    def name
      "Standalone"
    end

    def compile
      Dir.chdir(build_path) { puts "Standalone: do nothing"}
    end
    
    def release
      {
          "addons" => [],
          "config_vars" => {},
          "default_process_types" => default_process_types
      }.to_yaml
    end

    def default_process_types
       procfile["default_process_types"] || { "web" => "./standalone"}
    end

  end
end
