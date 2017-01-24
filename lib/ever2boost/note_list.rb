require 'securerandom'

module Ever2boost
  class NoteList
    DEFAULT_BYTES_NUMBER = 6

    attr_accessor :title, :hash, :guid

    def initialize(title: nil, hash: nil, guid: nil)
      @title = title
      @hash = SecureRandom.hex(DEFAULT_BYTES_NUMBER)
      @guid = guid
    end
  end
end
