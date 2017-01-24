module Ever2boost
  class CsonGenerator
    class << self
      DEFAULT_DIR_PATH = "#{ENV['HOME']}/ever2boost_store"

      def generate(folder_hash, note)
        timestamp = self.timestamp
        md_note_content = MdConverter.convert(note.content)
        cson = <<-EOS
          type: "MARKDOWN_NOTE"
          folder: "#{folder_hash}"
          title: "#{note.title}"
          content:
          '''
#{md_note_content}
          '''
          tags: []
          isStarred: false
          createdAt: "#{timestamp}"
          updatedAt: "#{timestamp}"
        EOS

        FileUtils.mkdir_p("#{DEFAULT_DIR_PATH}/notes") unless FileTest.exist?("#{DEFAULT_DIR_PATH}/notes")
        File.open("#{DEFAULT_DIR_PATH}/notes/#{note.file_name}.cson", "w") do |f|
          f.write(cson)
        end
      end

      def timestamp
        "2017-01-21T14:32:48.984Z"
      end
    end
  end
end
