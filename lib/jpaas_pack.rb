require "jpaas_pack/standalone.rb"

module JpaasPack

  def self.detect(*args)
    Dir.chdir(args.first)

    pack = [ Standalone ].detect do |klass|
      klass.use?
    end

    pack ? pack.new(*args) : nil
  end

end


