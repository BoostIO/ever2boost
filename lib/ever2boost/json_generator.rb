require 'json'
require 'ever2boost/util'

module Ever2boost
  class JsonGenerator
    class << self
      def build(notebook_list)
        folders = notebook_list.map do |list|
          {
            key: list.hash,
            name: list.title,
            color: list.color
          }
        end
        { folders: folders, version: '1.0' }.to_json
      end

      def output(notebook_list, output_dir)
        Util.make_notes_dir(output_dir)
        File.open("#{output_dir}/boostnote.json", 'w') do |f|
          f.write(build(notebook_list))
        end
      end
    end
  end
end
