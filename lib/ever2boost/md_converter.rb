require 'rexml/document'

module Ever2boost
  class MdConverter
    class << self
      def convert(note_content)
        en_note = nil
        # TODO: convert evernote xml to md
        REXML::Document.new(note_content).elements.each('*') { |el| en_note = el.to_s || en_note + el.to_s }
        if en_note.nil?
          note_content
        else
          # TODO: create conversion table
          en_note.gsub(/<en-note>(.*?)<\/en-note>/m, '\1')
                 .gsub(/<div(.*?)>(.*?)<\/div>/m, '\2')
                 .gsub(/<div(.*?)>/, '')
                 .gsub(/<\/div>/, '')
                 .gsub(/#+/, '\0 ')
                 .gsub(/<span(.*?)>(.*?)<\/span>/m, '\2')
                 .gsub(/<span(.*?)>/, '\2')
                 .gsub(/<\/span>/, '')
                 .gsub(/<ul>(.*?)<\/ul>/m, '\1')
                 .gsub(/<td(.*?)>(.*?)<\/td>/m, '\2')
                 .gsub(/<br(.*?)>/, '')
                 .gsub(/<li>(.*?)<\/li>/, '* \1')
                 .gsub(/<strong(.*?)>(.*?)<\/strong>/, '**\2**')
                 .gsub(/<a\ href=.(.*?).>(.*?)<\/a>/, '[\2](\1)')
        end
      end
    end
  end
end
