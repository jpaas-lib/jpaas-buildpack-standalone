require "yaml"
require "fileutils"
require "jpaas_pack/release"

module JpaasPack
  class Standalone

    extend JpaasPack::Release

    def self.use?
      framework ==  "standalone"
    end
    
    def self.framework
      release_info["framework"]
    end 
    

    attr_reader :build_path, :cache_path
    
    include JpaasPack::Release

    def initialize(build_path, cache_path=nil)
      @build_path = build_path
      @cache_path = cache_path
    end

    def name
      "Standalone"
    end

    def compile
      Dir.chdir(build_path) do |p|
        create_droplet_yaml
        puts "Standalone: do nothing but generate droplet.yaml"
      end
    end
    
    def release
      {
          "addons" => [],
          "config_vars" => {},
          "default_process_types" => default_process_types
      }.to_yaml
    end

    def default_process_types
       release_info["default_process_types"] || { "web" => "./jpaas_control start"}
    end
    
    def create_droplet_yaml
      droplet_file = File.join(build_path,"../droplet.yaml")
      File.open(droplet_file, 'w') { |f| YAML.dump(droplet_info, f) }
    end 

    def droplet_info
      droplet = {}
      [ "state_file", "start_timeout"].each do |key|
        droplet[key] = release_info[key] if release_info.key?(key)
      end 
      droplet.merge!("raw_ports" => ports_info)
    end 
    
    def ports_info
      raw_ports = {}                                                                 
      http_port = true                                                               
      release_info["ports"].each_pair do |k,v|                                                       
        raise "each port must be Integer" unless v.is_a?(Fixnum)                     
        raw_ports[k] = { "port" => v,                                                
                        "http" => http_port,                                         
                        "bns"  => true                                               
        }                                                                            
        http_port = false                                                            
      end                                                                            
     raw_ports                                                                       
    end 

  end
end
