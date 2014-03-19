require "yaml"

module JpaasPack
  module Release

    def release_file
      "Release"
    end

    def release_info
      @contents ||= File.exists?(release_file) ? YAML.load_file(release_file) : {}
      raise "Release: invalid yaml format" unless @contents.kind_of?(Hash)
      @contents
    end

  end
end
