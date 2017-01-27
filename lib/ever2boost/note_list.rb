require 'securerandom'

module Ever2boost
  class NoteList
    DEFAULT_BYTES_NUMBER = 6

    FOLDER_COLORS = [
      '#E10051',
      '#FF8E00',
      '#E8D252',
      '#3FD941',
      '#30D5C8',
      '#2BA5F7',
      '#B013A4'
    ].freeze

    attr_accessor :title, :hash, :guid, :color

    def initialize(title: nil, hash: nil, guid: nil, color: nil)
      index = ((Random.new.rand * 7) * 10.floor % 7).to_i
      color = FOLDER_COLORS[index]

      @title = title
      @hash = SecureRandom.hex(DEFAULT_BYTES_NUMBER)
      @guid = guid
      @color = color
    end
  end
end
