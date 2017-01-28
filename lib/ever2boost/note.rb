require 'securerandom'

module Ever2boost
  class Note
    DEFAULT_BYTES_NUMBER = 10
    attr_accessor :title, :content, :hash, :notebook_guid, :file_name, :output_dir
    def initialize(title: nil, content: nil, notebook_guid: nil, output_dir: nil)
      @title = title
      @content = content
      @notebook_guid = notebook_guid
      @file_name = SecureRandom.hex(DEFAULT_BYTES_NUMBER)
      @output_dir = output_dir
    end

    def md_content
      build_image_link(MdConverter.convert(content))
    end

    def build_image_link(content_str)
      content_str.gsub(/<en-media\ hash=['|"](.+?)['|"](.*?).\ type=.(.+?)\/(.+?)['|"](.*?)\/>/, "![#{'\1'}](#{self.output_dir}/images/#{'\1'}.#{'\4'})")
    end
  end
end
