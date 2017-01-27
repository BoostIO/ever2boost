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
                 .gsub(/<div(.*?)>(.*?)<\/div>/m, '\2\n')
                 .gsub(/<div(.*?)>/, '')
                 .gsub(/<\/div>/, '\n')
                 .gsub(/#+/, '\0 ')
                 .gsub(/<span(.*?)>(.*?)<\/span>/m, '\2')
                 .gsub(/<span(.*?)>/, '\2')
                 .gsub(/<\/span>/, '')
                 .gsub(/<ul>(.*?)<\/ul>/m, '\1')
                 .gsub(/<br(.*?)>/, '\n')
                 .gsub(/<li>(.*?)<\/li>/, '\n* \1')
                 .gsub(/<a\ href=.(.*?)[\'|\"](.*?)>(.*?)<\/a>/, '[\3](\1)')
                 .gsub(/<en-todo(.*?)>/, '*\ [\ ]\ ')
                 .gsub(/^(\ *)?/, '')
                 .gsub(/<strong>\\n<\/strong>/, '')
                 .gsub(/<strong(.*?)>(.*?)<\/strong>/, '**\2**')
                 .gsub(/<s>\\n<\/s>/, '')
                 .gsub(/<s>([^\n].+?)<\/s>/, '~~\1~~')
                 .gsub(/<i>\\n<\/i>/, '')
                 .gsub(/<i>([^\n].+?)<\/i>/, '*\1*')
                 .gsub(/<em>\\n<\/em>/, '')
                 .gsub(/<em>([^\n].+?)<\/em>/, '_\1_')
                 .gsub(/<b>([^\n].+?)<\/b>/, '**\1**')
                 .gsub(/<b>\\n<\/b>/, '')
                 .gsub(/<font(.*?)>(.*?)<\/font>/, '\2')
                 #.gsub(/<tr(.*?)>(.*?)<\/tr>(\n*?)/m, '\n|\2')
                 #.gsub(/<td(.*?)>(.*?)(\\n*?)<\/td>(\n*?)/m, '\2|')
                 # .gsub(/<table(.*?)>(.*?)<\/table>/m, '\2')
                 # .gsub(/<en-media\ hash=.(.+?).\ type=.(.+?)\/(.+?).\/>/, '![\1](\1.\3)')
        end
      end
    end
  end
end
