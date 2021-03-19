require_relative '../lib/error_printer'
require_relative '../lib/linters'
require_relative '../lib/reader'

describe Read do
  it 'should return an error invalid path given' do
    file = Read.new('./aloha')
    expect(file.error_msg).to eql('File path invalid')
  end
  it 'should return an error if nothing given' do
    file = Read.new(' ')
    expect(file.error_msg).to eql('File path invalid')
  end
  it 'should return the content in the file' do
    file = Read.new('./tester.rb')
    expect(file.content.length.positive?).to eql(false)
  end
end

describe Linter do
  describe '#lint_file' do
    it 'should return all errors in the file if tester given' do
      lint_test = Linter.new
      file = Read.new('./tester.rb')
      lint_test.lint_file(file.content)
      expect(lint_test.errors.length).to eql(0)
    end
    it 'should return and empty array if nothing given' do
      lint_test = Linter.new
      lint_test.lint_file([])
      expect(lint_test.errors.length).to eql(0)
    end
    it 'should return an empty array' do
      lint_test = Linter.new
      file = Read.new('./tester.rb')
      lint_test.lint_file(file.content)
      expect(lint_test.errors.empty?).to eql(true)
    end
    it 'should return false ' do
      lint_test = Linter.new
      file = Read.new('./tester.rb')
      lint_test.lint_file(file.content)
      expect(lint_test.errors.empty?).to_not eql(false)
    end
    describe '#next_line' do
      it 'should return the next line' do
        lint_test = Linter.new
        file = Read.new('./tester.rb')
        lint_test.lint_file(file.content)
        expect(lint_test.next_line(1)).to eql(1)
      end
    end
  end
end
