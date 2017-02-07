require 'rexml/document'

module Ever2boost
  class MdConverter
    class << self
      # params: String
      #   "<note>(/.*/)</note>" (import)
      #   or
      #   "<?xml>(/.*/)</en-note>" (convert)
      # return:
      #   markdown content
      def convert(note_content)

        en_note = nil
        REXML::Document.new(note_content).elements.each('*') { |el| en_note = el.to_s || en_note + el.to_s }
        if en_note.nil?
          note_content
        else
          # build table
          en_note.sub(/<tr(.*?)>(.*?)<\/tr>/m, '')
          number_of_row = $2.nil? ? 0 : $2.scan(/<\/td>/).size

          en_note.gsub(/<div(.*?)-en-codeblock(.*?)><div(.*?)>(.*?)<\/div><\/div>/, '\n```\n\4\n```')
          code_block = $4

          en_note.gsub(/<en-note(.*?)>(.*?)<\/en-note>/m, '\2')
                 .gsub(/<en-note\/>/, '')
                 .gsub(/<\/en-note>/, '')
                 .gsub(/\\n(\ *)/, '\n')
                 .gsub(/(\ *?)/m, '')
                 .gsub(/^\s*/, '')
                 .gsub(/<div(.*?)-en-codeblock(.*?)><div(.*?)>(.*?)<\/div><\/div>/, "\n```\n#{code_block}\n```")
                 .gsub(/<div(.*?)>(.*?)<\/div>/m, '\2')
                 .gsub(/<div(.*?)>/, '')
                 .gsub(/<\/div>/, '')
                 .gsub(/#+/, '\0 ')
                 .gsub(/<span(.*?)>(.*?)<\/span>/m, '\2')
                 .gsub(/<span(.*?)>/, '\2')
                 .gsub(/<\/span>/, '')
                 .gsub(/<p(.*?)>(.*?)<\/p>/m, '\2')
                 .gsub(/<p(.*?)>(.*?)<p\/>/m, '\2')
                 .gsub(/<p(.*?)>/m, '')
                 .gsub(/<ul(.*?)>(.*?)<\/ul>/m, '\2')
                 .gsub(/<br(.*?)>/, '\n')
                 .gsub(/<li(.*?)>(.*?)<\/li>/, '* \2')
                 .gsub(/<a\ href=['|"](.*?)['|"](.*?)>(.*?)<\/a>/m, '[\3](\1)')
                 .gsub(/<en-todo(.*?)>/, '*\ [\ ]\ ')
                 .gsub(/<strong>\\n<\/strong>/, '')
                 .gsub(/<strong(.*?)>(.*?)<\/strong>/, '**\2**')
                 .gsub(/<center(.*?)>(.*?)<\/center>/, '')
                 .gsub(/<s>\\n<\/s>/, '')
                 .gsub(/<s>([^\n].+?)<\/s>/, '~~\1~~')
                 .gsub(/<i>\\n<\/i>/, '')
                 .gsub(/<i>([^\n].+?)<\/i>/, '*\1*')
                 .gsub(/<i(.*?)>(.*?)<\/i>/m, '*\2*')
                 .gsub(/<em>\\n<\/em>/, '')
                 .gsub(/<em>([^\n].+?)<\/em>/, '_\1_')
                 .gsub(/<em(.*?)>(.*?)<\/em>/, '_\2_')
                 .gsub(/<b>([^\n].+?)<\/b>/, '**\1**')
                 .gsub(/<b>\\n<\/b>/, '')
                 .gsub(/<font(.*?)>(.*?)<\/font>/, '\2')
                 .gsub(/<tr(.*?)>(.*?)<\/tr>(\n*?)/m, '|\2')
                 .gsub(/<td(.*?)>(.*?)\n\\n<\/td>/m, '\2|')
                 .gsub(/<td(.*?)>(.*?)<\/td>/m, '\2|')
                 .gsub(/<\/tbody>/, '')
                 .gsub(/<\/table>/, '')
                 .gsub(/<table(.*?)>/, "#{'|' * (number_of_row + 1)}\n#{('|-' * (number_of_row + 1)).chop}")
                 .gsub(/<tbody(.*?)>/, '')
                 .gsub(/<p(.*?)>(.*?)<\/p>/, '\2')
                 .gsub(/<h1(.*?)>(.*?)<\/h1>/, '#\ \2')
                 .gsub(/<h2(.*?)>(.*?)<\/h2>/, '##\ \2')
                 .gsub(/<h3(.*?)>(.*?)<\/h3>/, '###\ \2')
                 .gsub(/<h4(.*?)>(.*?)<\/h4>/, '####\ \2')
                 .gsub(/<h5(.*?)>(.*?)<\/h5>/, '#####\ \2')
                 .gsub(/<pre(.*?)>(.*?)<code(.*?)>(.*?)<\/code><\/pre>/, '```\n\4\n```')
                 .gsub(/<code(.*?)>(.*?)<\/code>/, '\n```\n\2\n```\n')
                 .gsub(/<\/pre>/, '')
                 .gsub(/<hr(.*?)>/, '****')
                 .gsub(/ /m, ' ')
                 .gsub(/&gt;/, '>')
                 .gsub(/&lt;/, '<')
                 .gsub(/&amp;/, '&')
                 .gsub(/&quot;/, '"')
                 .gsub(/\\n\\n/m, '')
        end
      end
    end
  end
end
