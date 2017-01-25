module Ever2boost
  class JsonGenerator
    class << self
      def build(notebook_list)
        folders = <<-EOS
        EOS

        notebook_list.each do |list|
          brace = notebook_list.last == list ? '}' : '},'
          folders += <<-EOS
    {
      "key": "#{list.hash}",
      "name": "#{list.title}",
      "color": "#{list.color}"
    #{brace}
          EOS
        end

        json = <<-EOS
{
  "folders": [
#{folders.chomp}
  ],
  "version": "1.0"
}
        EOS
      end

      def output(notebook_list, output_dir)
        File.open("#{output_dir}/boostnote.json","w") do |f|
          f.write(self.build(notebook_list))
        end
      end
    end
  end
end
