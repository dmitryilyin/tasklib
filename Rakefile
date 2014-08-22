require 'rubygems'
require 'find'
require 'yaml'
require 'tasklib/utils'
require 'tasklib/config'
require 'tasklib/task'
require 'tasklib/agent'
require 'tasklib/action'
require 'tasklib/action/puppet'
require 'tasklib/action/exec'
require 'tasklib/action/rspec'


# create rake task and sub-tasks
# @param directory [String]
def make_task(directory)
  Tasklib::Utils.debug "Start to make task for the directory #{directory}"
  task = Tasklib::Task.new directory
  name = task.name
  task.set_plugins

  actions = %w(pre run post)
  actions.each do |action|
    next unless task.has_action? action
    Tasklib::Utils.debug "Make rake task #{name}::#{action}"
    namespace name do
      task action do
        Tasklib::Utils.debug "Run rake task: #{name} action: #{action}"
        task.send action.to_sym
        task.report_output action
        Tasklib::Utils.debug "End rake task: #{name} action: #{action}"
      end
      task "#{action}/report" do
        task.report_output action
      end
      task "#{action}/raw" do
        task.report_raw action
      end
      task "#{action}/remove" do
        task.report_remove action
      end
      task "#{action}/success" do
        task.success? action
      end
    end
  end

  unless Rake.application.tasks.select { |t| t.name == name }.any?
    if task.title
      desc task.title
    else
      desc "#{name} task"
    end
    task name do
      all_tasks = Rake.application.tasks.map { |t| t.name }
      Tasklib::Utils.debug "Run full rake task: #{name}"
      if all_tasks.include? "#{name}:pre"
        Rake::Task["#{name}:pre"].invoke
        raise "Pre-deployment test of task \"#{name}\" failed!" if task.fail? 'pre'
      end
      if all_tasks.include? "#{name}:run"
        Rake::Task["#{name}:run"].invoke
        raise "Run of task \"#{name}\" failed!" if task.fail? 'run'
      end
      if all_tasks.include? "#{name}:post"
        Rake::Task["#{name}:post"].invoke
        raise "Post-deployment test of task \"#{name}\" failed!" if task.fail? 'post'
      end
      Tasklib::Utils.debug "End full rake task: #{name}"
    end
    task "#{name}/info" do
      puts task.description
    end
  end

end

# deploy preset of tasks
# argument start_task can set fist task to do
# list can display tasks in preset
# @param name [String]
# @param tasks [Array<String>]
# @param comment [String]
def deploy_preset(name, tasks, comment = nil)
  desc comment ? comment : "Preset deploymnet: #{name}"
  task "preset/#{name}", :start_task do |t, args|
    fail "No tasks in preset #{name}!" unless tasks.respond_to?(:each) && tasks.any?
    start_task_number = nil
    start_task_number = tasks.index(args.start_task) if args.start_task
    if start_task_number && start_task_number > 0
      tasks = tasks.drop(start_task_number || 0)
    end
    tasks.each do |task|
      Rake::Task[task].invoke
    end
  end
  task "preset/#{name}/list" do
    tasks.each_with_index do |task, num|
      puts "#{num + 1} #{task}"
    end
  end
end

##############################################################

# settings
Rake::TaskManager.record_task_metadata = true
ENV['LANG'] = 'C'
presets_file = 'etc/presets.yaml'

# load presets data from file
if File.exists? presets_file
  presets = YAML.load_file presets_file
  raise 'Error parsing presets file!' unless presets and presets.is_a? Hash
  presets.each do |name, tasks|
    deploy_preset name, tasks
  end
end

# gather all tasks as rake jobs
Dir.chdir Tasklib::Config[:task_dir] or raise "Cannot change directory to #{Tasklib::Config[:task_dir]}"

Find.find(Tasklib::Config[:library_dir] + '/') do |path|
  next unless File.file? path and File.basename(path) == Tasklib::Config[:task_file]
  directory = File.dirname path
  make_task directory
end

# show main tasks
task 'list' do
  tasks = Rake.application.tasks
  presets = tasks.select { |t| t.comment and t.name.start_with? 'preset/' }
  main_tasks = tasks.select { |t| t.comment and not t.name.start_with? 'preset/' }
  Tasklib::Utils.print_tasks_list presets
  puts
  Tasklib::Utils.print_tasks_list main_tasks
end

# show main tasks by default
task 'list/all' do
  tasks = Rake.application.tasks
  presets = tasks.select { |t| t.name.start_with? 'preset/' }
  main_tasks = tasks.select { |t| !t.name.start_with? 'preset/' }
  Tasklib::Utils.print_tasks_list presets
  puts
  Tasklib::Utils.print_tasks_list main_tasks
end

task :default => [:list]
