require 'securerandom'

module Ever2boost
  class Note
    DEFAULT_BYTES_NUMBER = 10
    attr_accessor :title, :content, :hash, :notebook_guid, :file_name, :output_dir
    def initialize(title: nil, content: nil, notebook_guid: nil, output_dir: nil)
      @title = title
      @content = content
      @notebook_guid = notebook_guid
      @file_name = SecureRandom.hex(DEFAULT_BYTES_NUMBER)
      @output_dir = output_dir
    end

    def md_content
      MdConverter.convert(content).gsub(/<en-media\ hash=.(.+?).\ type=.(.+?)\/(.+?).\/>/, "![\1](#{self.output_dir}\1.\3)")
    end
  end
end
