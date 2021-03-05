require 'colorize'

class Reader
  attr_reader :err, :file_lines, :file_path, :line_count
  def initialize(file_path)
    @err = ''
    @file_path = file_path
    begin
      @file_lines = File.readlines(@file_path)
      @line_count = @file_lines.size
    rescue StandardError => e
      @file_lines = []
      @err = "Check file name and path \n".colorize(:light_red) + e.to_s.colorize(:red)
    end
  end
end