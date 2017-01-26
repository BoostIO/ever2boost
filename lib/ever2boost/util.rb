module Ever2boost
  class Util
    class << self
      def make_output_dir(output_dir)
        FileUtils.mkdir_p("#{output_dir}/notes") unless FileTest.exist?("#{output_dir}/notes")
      end
    end
  end
end
