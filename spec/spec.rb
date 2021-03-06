require_relative '../lib/linters'

RSpec.describe Error do
  let(:checker) { Error.new('tester.rb') }

  describe '#check_empty_line' do
    it 'returns error when extra empty lines' do
      checker.check_empty_line
      expect(checker.errors[0]).to eql('line:6 Extra space detected at block end')
    end
  end

  describe '#check_indentation' do
    it 'returns error when wrong indentation level' do
      checker.check_indentation
      expect(checker.errors[0]).to eql('line:4 Use 2 spaces for indentation.')
    end
  end

  describe '#check_trailing' do
    it 'returns error when extra whitespace' do
      checker.check_trailing_spaces
      expect(checker.errors[0]).to eql('line:4:19: Trailing whitespace detected.')
    end
  end

  describe '#check_tag_error' do
    it 'returns error when wrong tag syntax is used' do
      checker.check_tag_error
      expect(checker.errors[0]).to eql("line:5 Unexpected/Missing token ']' Square Bracket")
    end
  end

  describe '#check_end_error' do
    it "returns error missing or unexpected 'end'" do
      checker.check_end_error
      expect(checker.errors[0]).to eql("Missing 'end'")
    end
  end
end
