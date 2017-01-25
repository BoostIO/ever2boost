module Ever2boost
  class CsonGenerator
    class << self
      def generate(folder_hash, note, output_dir)
        timestamp = self.timestamp
        md_note_content = MdConverter.convert(note.content)
        cson = <<-EOS
type: "MARKDOWN_NOTE"
folder: "#{folder_hash}"
title: "#{note.title}"
content: '''
  # #{note.title}
  #{md_note_content}
'''
tags: []
isStarred: false
createdAt: "#{timestamp}"
updatedAt: "#{timestamp}"
        EOS

        FileUtils.mkdir_p("#{output_dir}/notes") unless FileTest.exist?("#{output_dir}/notes")
        File.open("#{output_dir}/notes/#{note.file_name}.cson", "w") do |f|
          f.write(cson)
        end
      end

      def timestamp
        "2017-01-21T14:32:48.984Z"
      end
    end
  end
end
