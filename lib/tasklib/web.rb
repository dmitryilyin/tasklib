module Tasklib
  def self.web
    return @html if @html
    @index_file = File.join File.dirname(__FILE__), 'rest.html'
    @html = nil
    if File.exist? @index_file
      begin
        @html = File.read @index_file
      rescue
        @html = nil
        'No HTML file!'
      end
    end
  end
  def self.web_reload
    @html = nil
    self.web
  end
end