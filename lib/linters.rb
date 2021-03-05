require 'colorize'
require 'strscan'
require_relative 'reader.rb'

class Error
  attr_reader :checker, :errors

  def initialize(file_path)
    @checker = Reader.new(file_path)
    @errors = []
    @keywords = %w[if do def case class unless begin module]
  end

  def check_empty_line
    @checker.file_lines.each_with_index do |str_val, indx|
      check_def_empty_line(str_val, indx)
      check_do_empty_line(str_val, indx)
      check_class_empty_line(str_val, indx)
      check_end_empty_line(str_val, indx)
    end
  end

  def check_def_empty_line(str_val, indx)
    msg1 = 'Extra space detected at method beginning'
    msg2 = 'Use empty lines between methods'

    return unless str_val.strip.split(' ').first.eql?('def')

    log_error("line:#{indx + 2} #{msg1}") if @checker.file_lines[indx + 1].strip.empty?
    log_error("line:#{indx + 1} #{msg2}") if @checker.file_lines[indx - 1].strip.split(' ').first.eql?('end')
  end

  def check_do_empty_line(str_val, indx)
    msg = 'Extra space detected at block beginning'
    return unless str_val.strip.split(' ').include?('do')

    log_error("line:#{indx + 2} #{msg}") if @checker.file_lines[indx + 1].strip.empty?
  end

  def check_class_empty_line(str_val, indx)
    msg = 'Extra space detected at class beginning'
    return unless str_val.strip.split(' ').first.eql?('class')

    log_error("line:#{indx + 2} #{msg}") if @checker.file_lines[indx + 1].strip.empty?
end

  def check_end_empty_line(str_val, indx)
    return unless str_val.strip.split(' ').first.eql?('end')

    log_error("line:#{indx} Extra space detected at block end") if @checker.file_lines[indx - 1].strip.empty?
  end
