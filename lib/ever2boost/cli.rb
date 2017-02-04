require 'thor'
require 'ever2boost/evernote_authorizer'
require 'ever2boost/enex_converter'
require 'ever2boost/util'

module Ever2boost
  class CLI < Thor
    DEFAULT_OUTPUT_DIR = "#{ENV['HOME']}/evernote_storage".freeze
    DEFAULT_OUTPUT_DIR_ENEX = "#{ENV['HOME']}/evernote_storage_enex".freeze

    desc 'import', 'import from evernote'
    option :directory, aliases: :d, banner: 'DIRCTORY_PATH', desc: 'make Boostnote storage in the directory default: ~/evernote_storage'
    def import
      output_dir = options[:directory] || DEFAULT_OUTPUT_DIR
      developer_token = ask('DEVELOPER_TOKEN:')
      EvernoteAuthorizer.new(developer_token).import(output_dir)
    end

    desc 'convert', 'convert from .enex'
    option :directory, aliases: :d, banner: 'DIRCTORY_PATH', desc: 'make Boostnote storage in the directory default: ~/evernote_storage'
    def convert(path)
      output_dir = options[:directory] || DEFAULT_OUTPUT_DIR_ENEX
      abort Util.red_output("Error! No such file or directory: #{path}") unless File.exist?(path)
      enex = File.read(path)
      filename = File.basename(path, '.enex')
      EnexConverter.convert(enex, output_dir, filename)
    end

    map %w[--version -v] => :__print_version
    desc "--version, -v", "print the version"
    def __print_version
      puts Ever2boost::VERSION
    end
  end
end
