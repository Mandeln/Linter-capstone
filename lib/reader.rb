class Read
  attr_reader :path_to, :error_msg, :content

  def initialize(path)
    @path_to = path
    @error_msg = ''
    begin
      File.open(path) do |file|
        @content = file.readlines.map(&:chomp)
      end
    rescue StandardError
      @content = []
      @error_msg = 'File path invalid'
    end
  end
end
