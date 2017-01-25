require 'json'

module Ever2boost
  class JsonGenerator
    class << self
      def build(notebook_list)
        {
          folders: notebook_list.map { |list|
            {
              key: list.hash,
              name: list.title,
              color: list.color
            }
          },
          version: '1.0'
        }.to_json
      end

      def output(notebook_list, output_dir)
        File.open("#{output_dir}/boostnote.json","w") do |f|
          f.write(self.build(notebook_list))
        end
      end
    end
  end
end
