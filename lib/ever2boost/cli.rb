require 'thor'
require 'ever2boost/evernote_authorizer'

module Ever2boost
  class CLI < Thor
    desc "import", "import from evernote"
    def import
      developer_token = ask('DEVELOPER_TOKEN: ')
      EvernoteAuthorizer.new(developer_token).fetch_notes(100)
    end
  end
end
