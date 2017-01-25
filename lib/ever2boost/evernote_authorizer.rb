require 'evernote-thrift'
require 'ever2boost/note'
require 'ever2boost/note_list'

module Ever2boost
  class EvernoteAuthorizer
    EVERNOTE_HOST = "www.evernote.com"

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

    def fetch_notebook_list
      self.note_store.listNotebooks(self.developer_token)
    end

    def notebook_guids
      self.fetch_notebook_list.map(&:guid)
    end

    def notebook_list
      guids = self.notebook_guids
      self.fetch_notebook_list.map { |nl| Ever2boost::NoteList.new(title: nl.name, hash: nl.hash, guid: nl.guid) }
    end

    def number_of_note(filter)
      note_counts_hash = self.note_store.findNoteCounts(self.developer_token, filter, true).notebookCounts
      note_counts_hash.values.last || 0
    end

    def fetch_notes(filter)
      spec = Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new(includeTitle: true, includeNotebookGuid: true)

      # get latest 250 notes
      # TODO: display message like "ignored first #{(number_of_notes - 250).to_s} notes due to EvernoteAPI access limitation" if number_of_notes > 250
      start_index = self.number_of_note(filter) > 250 ? self.number_of_note(filter) - 250 : 0
      self.note_store.findNotesMetadata(self.developer_token, filter, start_index, 15, spec)
    end

    # Download the all of notes fron Evernote and generate Boostnote storage from it
    # TODO: move this method to CLI
    def import(output_dir)
      FileUtils.mkdir_p(output_dir) unless FileTest.exist?(output_dir)

      Ever2boost::JsonGenerator.generate_boostnote_json(self.notebook_list, output_dir)

      self.notebook_guids.each do |notebook_guid|
        filter = Evernote::EDAM::NoteStore::NoteFilter.new(notebookGuid: notebook_guid)
        note_guids = self.fetch_notes(filter).notes.map(&:guid)
        # TODO: assign the booleans
        en_notes = note_guids.map {|note_guid| self.note_store.getNote(self.developer_token, note_guid, true, true, false, false)}
        notes = en_notes.map {|note| Note.new(title: note.title, content: note.content, notebook_guid: note.notebookGuid)}
        notes.each do |note|
          self.notebook_list.each do |list|
            # TODO: break if note not found
            CsonGenerator.generate(list.hash, note, output_dir) if list.guid == note.notebook_guid
          end
        end
      end
    end
  end
end
