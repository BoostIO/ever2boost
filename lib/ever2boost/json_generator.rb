module Ever2boost
  class JsonGenerator
    FOLDER_COLORS = [
      '#E10051',
      '#FF8E00',
      '#E8D252',
      '#3FD941',
      '#30D5C8',
      '#2BA5F7',
      '#B013A4'
    ].freeze

    class << self
      def build(notebook_list)
        folders = <<-EOS
        EOS

        notebook_list.each do |list|
          random_color = self.random_color
          brace = notebook_list.last == list ? '}' : '},'
          folders += <<-EOS
            {
              "key": "#{list.hash}",
              "name": "#{list.title}",
              "color": "#{random_color}"
            #{brace}
          EOS
        end

        json = <<-EOS
          {
            "folders": [
              #{folders}
            ],
            "version": "1.0"
          }
        EOS
      end

      def random_color
        index =  ((Random.new().rand * 7)*10.floor % 7).to_i
        FOLDER_COLORS[index]
      end

      def output(notebook_list, output_dir)
        File.open("#{output_dir}/boostnote.json","w") do |f|
          f.write(self.build(notebook_list))
        end
      end
    end
  end
end
