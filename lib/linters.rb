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

  def log_error(error_msg)
    @errors << error_msg
  end
end

  def check_indentation
    msg = 'Use 2 spaces for indentation.'
    cur_val = 0
    indent_val = 0

    @checker.file_lines.each_with_index do |str_val, indx|
      strip_line = str_val.strip.split(' ')
      exp_val = cur_val * 2
      res_word = %w[class def if elsif until module unless begin case]

      next unless !str_val.strip.empty? || !strip_line.first.eql?('#')

      indent_val += 1 if res_word.include?(strip_line.first) || strip_line.include?('do')
      indent_val -= 1 if str_val.strip == 'end'

      next if str_val.strip.empty?

      indent_error(str_val, indx, exp_val, msg)
      cur_val = indent_val
    end
  end

  def indent_error(str_val, indx, exp_val, msg)
    strip_line = str_val.strip.split(' ')
    emp = str_val.match(/^\s*\s*/)
    end_chk = emp[0].size.eql?(exp_val.zero? ? 0 : exp_val - 2)

    if str_val.strip.eql?('end') || strip_line.first == 'elsif' || strip_line.first == 'when'
      log_error("line:#{indx + 1} #{msg}") unless end_chk
    elsif !emp[0].size.eql?(exp_val)
      log_error("line:#{indx + 1} #{msg}")
    end
  end

  def check_trailing
    @checker.file_lines.each_with_index do |str_val, index|
      if str_val[-2] == ' ' && !str_val.strip.empty?
        @errors << "line:#{index + 1}:#{str_val.size - 1}: Error: Trailing whitespace detected."
        + " '#{str_val.gsub(/\s*$/, '_')}'"
      end
    end
  end