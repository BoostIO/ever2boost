require 'evernote-thrift'
require 'ever2boost/note'
require 'ever2boost/note_list'
require 'pry-byebug'

module Ever2boost
  class EvernoteAuthorizer
    EVERNOTE_HOST = "www.evernote.com"
    DEFAULT_DIR_PATH = "#{ENV['HOME']}/ever2boost_store"

    attr_accessor :developer_token, :note_store

    def initialize(developer_token)
      user_store_url = "https://#{EVERNOTE_HOST}/edam/user"
      user_store_transport = Thrift::HTTPClientTransport.new(user_store_url)
      user_store_protocol = Thrift::BinaryProtocol.new(user_store_transport)
      user_store = Evernote::EDAM::UserStore::UserStore::Client.new(user_store_protocol)
      note_store_url = user_store.getNoteStoreUrl(developer_token)
      note_store_transport = Thrift::HTTPClientTransport.new(note_store_url)
      note_store_protocol = Thrift::BinaryProtocol.new(note_store_transport)
      note_store = Evernote::EDAM::NoteStore::NoteStore::Client.new(note_store_protocol)
      @developer_token = developer_token
      @note_store = note_store
    end

    def fetch_notes(number_of_notes)
      FileUtils.mkdir_p(DEFAULT_DIR_PATH) unless FileTest.exist?(DEFAULT_DIR_PATH)

      start_index = 0
      note_store = self.note_store
      notebook_list = note_store.listNotebooks(self.developer_token)
      notebook_guids = notebook_list.map(&:guid)
      lists = notebook_list.map { |nl| Ever2boost::NoteList.new(title: nl.name, hash: hash, guid: nl.guid) }
      Ever2boost::JsonGenerator.generate_boostnote_json(lists)
      filter = Evernote::EDAM::NoteStore::NoteFilter.new
      filter.notebookGuid = notebook_guids.first
      note_list = note_store.findNotes(self.developer_token, filter, start_index, number_of_notes)
      # TODO: note_listのtitleからboostnote.jsonを作成する。
      note_guids = note_list.notes.map(&:guid)
      # TODO: assign the booleans
      en_notes = note_guids.map {|note_guid| note_store.getNote(self.developer_token, note_guid, true, true, false, false)}
      notes = en_notes.map {|note| Note.new(title: note.title, content: note.content, notebook_guid: note.notebookGuid)}
      notes.each do |note|
        lists.each do |list|
          # TODO: break if note found
          CsonGenerator.generate(list.hash, note) if list.guid == note.notebook_guid
        end
      end
    end
  end
end
