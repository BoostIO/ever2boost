module Ever2boost
  class Util
    class << self
      def make_output_dir(output_dir)
        FileUtils.mkdir_p("#{output_dir}/notes") unless FileTest.exist?("#{output_dir}/notes")
      end

      def red_output(str)
        "\e[31m#{str}\e[0m"
      end

      def green_output(str)
        "\e[32m#{str}\e[0m"
      end

      def yellow_output(str)
        "\e[33m#{str}\e[0m"
      end
    end
  end
end
