$:.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'tasklib/version'

Gem::Specification.new do |s|
  s.name = 'tasklib'
  s.version = Tasklib::VERSION

  s.summary = 'Deployment Task Library'
  s.description = 'Task API library used to run deploytment tasks on managed nodes'
  s.authors = ['Dmitry Ilyin']
  s.email   = ['dilyin@mirantis.com']
  s.homepage = 'http://mirantis.com'
  s.license = 'Apache v3.0'

  s.files   = Dir.glob("{bin,lib,spec,etc,library}/**/*")
  s.executables = ['taskcmd', 'taskweb']
  s.require_path = 'lib'

  s.add_dependency 'json'
  s.add_dependency 'rake'
  s.add_dependency 'daemons'

  s.add_dependency 'sinatra'

  s.add_dependency 'serverspec'
  s.add_dependency 'rspec_junit_formatter'
  s.add_dependency 'puppet'

end
