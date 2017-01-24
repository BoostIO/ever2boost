require 'securerandom'

module Ever2boost
  class Note
    DEFAULT_BYTES_NUMBER = 10
    attr_accessor :title, :content, :hash, :notebook_guid, :file_name
    def initialize(title: nil, content: nil, hash: nil, notebook_guid: nil)
      @title = title
      @content = content
      @hash = hash
      @notebook_guid = notebook_guid
      @file_name = SecureRandom.hex(DEFAULT_BYTES_NUMBER)
    end
  end
end
