require 'yaml'
require 'pathname'

module Tasklib

  # deploymnet configuration class #
  class Config

    # a set of default config values
    # @return [Hash]
    def self.default_config
      return @default_config if @default_config
      current_dir = Pathname.new(__FILE__).expand_path.dirname.realpath
      task_dir = current_dir.dirname.dirname
      library_dir = task_dir + 'library'
      config_file = task_dir + 'etc' + 'config.yaml'
      @default_config = {
          :task_dir => task_dir.to_s,
          :library_dir => library_dir.to_s,
          :module_dir => '/etc/puppet/modules',
          :puppet_options => '',
          :report_format => 'xunit',
          :report_extension => 'xml',
          :report_dir => '/tmp/task_report',
          :pid_dir => '/tmp/task_run',
          :puppet_manifest => 'site.pp',
          :spec_pre => 'spec/pre_spec.rb',
          :spec_post => 'spec/post_spec.rb',
          :task_file => 'task.yaml',
          :debug => false,
          :config_file => config_file.to_s,
      }
    end

    # this module method loads task config file
    # and sets default values for values not present
    # in config file
    # @return [Hash]
    def self.config
      return @config if @config
      config_file = self.default_config[:config_file]
      if File.exist? config_file
        @config = YAML.load_file(config_file)
        if @config.is_a? Hash
          @config = self.default_config.merge @config
        end
      else
        @config = self.default_config
      end
    end

    # makes possible to access config like this
    # Deploy::Config.task_dir
    def self.method_missing(key)
      self.config[key]
    end

    # makes possible to access config like this
    # Deploy::Config[:task_dir]
    def self.[](key)
      self.config[key]
    end

  end # class

end # module
