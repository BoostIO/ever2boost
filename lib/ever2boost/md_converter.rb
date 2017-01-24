require 'rexml/document'
require 'byebug'

module Ever2boost
  class MdConverter
    class << self
      def convert(note_content)
        en_note = nil
        # TODO: convert evernote xml to md
        REXML::Document.new(note_content).elements.each('*') {|el| en_note = el.to_s || en_note + el.to_s }
        en_note.gsub(/<en-note>/, '')
               .gsub(/<\/en-note>/, '')
               .gsub(/<div>/, '')
               .gsub(/<\/div>/, '')
               .gsub(/<br\/>/, '\n\r')
      end
    end
  end
end
