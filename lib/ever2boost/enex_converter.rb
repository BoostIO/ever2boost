require 'rexml/document'
require 'ever2boost/util'

module Ever2boost
  class EnexConverter
    class << self
      def convert(enex, output_dir, filename)
        puts 'converting...'
        en_notes = []
        REXML::Document.new(Ever2boost::MdConverter.convert(enex)).elements['en-export'].each { |el| en_notes.push(el.to_s) }
        en_notes.delete("\n")
        notes = en_notes.map do |note|
          title = REXML::Document.new(note).elements['note/title'].text
          puts "converting #{title}"
          Note.new(title: title, content: "<div>#{REXML::Document.new(note).elements['note/content/text()'].value.sub(/.+\n/, '').sub(/.+\n/, '')}</div>")
        end
        notebook_list = [NoteList.new(title: filename)]
        JsonGenerator.output(notebook_list, output_dir)
        notes.each do |note|
          CsonGenerator.output(notebook_list.first.hash, note, output_dir)
        end
        puts Util.green_output("The notes are created at #{output_dir}")
      end
    end
  end
end
