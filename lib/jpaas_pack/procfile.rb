require "yaml"

module JpaasPack
  module Procfile

    def procfile_path
      File.join(build_path,"Procfile")
    end

    def procfile
      @contents ||= File.exists?(procfile_path) ? YAML.load_file(procfile_path) : {}
      raise "Procfile: invalid yaml format" unless @contents.kind_of?(Hash)
      @contents
    end

  end
end
