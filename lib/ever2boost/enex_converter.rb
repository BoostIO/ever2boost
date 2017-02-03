require 'rexml/document'
require 'ever2boost/util'

module Ever2boost
  class EnexConverter
    class << self
      def convert(enex, output_dir, filename)
        puts 'converting...'
        en_notes = parse_plural_notes(enex, output_dir)
        notebook_list = [NoteList.new(title: filename)]
        JsonGenerator.output(notebook_list, output_dir)
        en_notes.each do |note|
          puts "converting #{note.title}"
          CsonGenerator.output(notebook_list.first.hash, note, output_dir)
        end
        puts Util.green_output("The notes are created at #{output_dir}")
      end

      # enex: String
      #   "<?xml>(.*)</en-export>"
      # return: Array
      #   include Note objects
      #   note.content = "<note>(.*)</note>"
      # comment:
      #   A .enex file include plural ntoes. Thus I need to handle separation into each note.
      def parse_plural_notes(enex, output_dir)
        REXML::Document.new(enex).elements['en-export'].map do |el|
          if el != "\n"
            xml_document = REXML::Document.new(el.to_s).elements
            Note.new({
              title: xml_document['note/title'].text,
              content: "<div>#{xml_document['note/content/text()'].to_s.sub(/<\?xml(.*?)\?>(.*?)<\!DOCTYPE(.*?)>/m, '')}</div>",
              output_dir: output_dir
            })
          end
        end.compact.flatten
      end
    end
  end
end
