require 'thor'
require 'ever2boost/evernote_authorizer'

module Ever2boost
  class CLI < Thor
    DEFAULT_OUTPUT_DIR = "#{ENV['HOME']}/ever2boost_store"

    desc "import", "import from evernote"
    def import
      developer_token = ask('DEVELOPER_TOKEN:')
      EvernoteAuthorizer.new(developer_token).import(DEFAULT_OUTPUT_DIR)
    end

    class << self
      def tell(message)
        tell(message)
      end
    end
  end
end
