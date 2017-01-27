require 'securerandom'

module Ever2boost
  class Note
    DEFAULT_BYTES_NUMBER = 10
    attr_accessor :title, :content, :hash, :notebook_guid, :file_name
    def initialize(title: nil, content: nil, notebook_guid: nil)
      @title = title
      @content = content
      @notebook_guid = notebook_guid
      @file_name = SecureRandom.hex(DEFAULT_BYTES_NUMBER)
    end

    def md_content
      MdConverter.convert(content)
    end
  end
end
