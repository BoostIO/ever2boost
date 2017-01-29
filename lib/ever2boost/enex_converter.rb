require 'rexml/document'
require 'ever2boost/util'

module Ever2boost
  class EnexConverter
    class << self
      def convert(enex, output_dir, filename)
        puts 'converting...'
        en_notes = parse_plural_notes(enex)
        notes = en_notes.map do |note|
          title = note.title
          puts "converting #{title}"
          # note: String
          #   "<note>(.*)</note>
          content = "<div>#{note.content}</div>"
          Note.new(title: title, content: content, output_dir: output_dir)
        end
        notebook_list = [NoteList.new(title: filename)]
        JsonGenerator.output(notebook_list, output_dir)
        notes.each do |note|
          CsonGenerator.output(notebook_list.first.hash, note, output_dir)
        end
        puts Util.green_output("The notes are created at #{output_dir}")
      end

      # enex: String
      #   "<?xml>(.*)</en-export>"
      def parse_plural_notes(enex)
        REXML::Document.new(Ever2boost::MdConverter.convert(enex)).elements['en-export'].map do |el|
          unless el == "\n"
            xml_document = REXML::Document.new(el.to_s).elements
            title = xml_document['note/title'].text
            content = xml_document['note/content/text()'].to_s.sub(/.+\n/, '').sub(/.+\n/, '')
            Note.new(title: title, content: content)
          end
        end.compact.flatten
      end
    end
  end
end
