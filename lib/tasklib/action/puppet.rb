require 'English'

module Tasklib
  # run puppet manifest as a task
  class PuppetAction < Action

    # @param task [Tasklib::Task]
    # @param action [String]
    # @param manifest [String]
    def initialize(task, action, manifest = nil)
      @file = manifest
      @file = Tasklib::Config[:puppet_manifest] unless @file
      super task, action
    end

    # return this action's file name
    # @return [String]
    def file
      @file
    end

    # return the full path to ths action's file
    # @return [String]
    def path
      path = File.expand_path File.join task.directory, file
      @path = path
    end

    # is there a puppet manifest of this action
    def exists?
      File.exists? path and File.readable? path
    end

    # write the report file with success
    # telling that there is no puppet manifest
    def report_no
      report = {
          :classname => self.class,
          :name => 'No Manifest',
      }
      report_write Tasklib::Utils.make_xunit report
    end

    # write the report file with success
    # telling that puppet apply went ok
    def report_ok
      report = {
          :classname => self.class,
          :name => 'Puppet Apply',
      }
      report_write Tasklib::Utils.make_xunit report
    end

    # write the report file with success
    # telling that puppet apply had errors
    def report_fail
      report = {
          :classname => self.class,
          :name => 'Puppet Apply',
          :failure => {
              :message => 'Puppet Error',
              :text => "Puppet manifest '#{path}' apply have failed!"
          }
      }
      report_write Tasklib::Utils.make_xunit report
    end

    # create a puppet command line
    # @return [String]
    def puppet_command
      puppet_command = 'puppet apply --detailed-exitcodes'
      puppet_command += " --modulepath='#{Tasklib::Config[:module_dir]}'" if Tasklib::Config[:module_dir]
      puppet_command + " #{Tasklib::Config[:puppet_options]}" if Tasklib::Config[:puppet_options]
    end

    # start the puppet run
    # @return[Fixnum]
    def call
      Tasklib::Utils.debug "Start #{self.class} with action '#{action.to_s}' and '#{path}' manifest"
      unless exists?
        report_no
        return 0
      end
      report_remove
      system "#{puppet_command} #{path}"
      exit_code = $CHILD_STATUS.exitstatus
      if [0, 2].include? exit_code
        report_ok
      else
        report_fail
      end
      exit_code
    end

  end

end