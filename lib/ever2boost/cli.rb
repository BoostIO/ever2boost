require 'thor'
require 'ever2boost/evernote_authorizer'

module Ever2boost
  class CLI < Thor
    DEFAULT_OUTPUT_DIR = "#{ENV['HOME']}/evernote_storage"

    desc "import", "import from evernote"
    option :directory, aliases: :d, banner: 'DIRCTORY_PATH', desc: "make Boostnote storage in the directory\ndefault: ~/evernote_storage"
    def import
      output_dir = options[:directory] || DEFAULT_OUTPUT_DIR
      developer_token = ask('DEVELOPER_TOKEN:')
      EvernoteAuthorizer.new(developer_token).import(output_dir)
    end
  end
end
