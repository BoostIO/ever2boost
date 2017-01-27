require 'evernote-thrift'
require 'ever2boost/note'
require 'ever2boost/note_list'

module Ever2boost
  class EvernoteAuthorizer
    EVERNOTE_HOST = 'www.evernote.com'.freeze

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
    rescue => e
      abort_with_message e
    end

    def fetch_notebook_list
      note_store.listNotebooks(developer_token)
    end

    def notebook_guids
      fetch_notebook_list.map(&:guid)
    end

    def notebook_list
      guids = notebook_guids
      fetch_notebook_list.map { |nl| Ever2boost::NoteList.new(title: nl.name, guid: nl.guid) }
    end

    def number_of_note(filter)
      note_counts_hash = note_store.findNoteCounts(developer_token, filter, true).notebookCounts
      note_counts_hash.nil? ? 0 : note_counts_hash.values.last
    end

    def fetch_notes(filter)
      spec = Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new(includeTitle: true, includeNotebookGuid: true)
      number_of_note = self.number_of_note(filter)

      # get latest 250 notes
      # TODO: display message like "ignored first #{(number_of_notes - 250).to_s} notes due to EvernoteAPI access limitation" if number_of_notes > 250
      start_index = number_of_note > 250 ? number_of_note - 250 : 0
      note_store.findNotesMetadata(developer_token, filter, start_index, number_of_note, spec)
    end

    # Download the all of notes fron Evernote and generate Boostnote storage from it
    # TODO: move this method to CLI
    def import(output_dir)
      puts 'processing...'
      FileUtils.mkdir_p(output_dir) unless FileTest.exist?(output_dir)
      notebook_list = self.notebook_list

      Ever2boost::JsonGenerator.output(notebook_list, output_dir)

      notebook_guids.each do |notebook_guid|
        filter = Evernote::EDAM::NoteStore::NoteFilter.new(notebookGuid: notebook_guid)
        note_guids = fetch_notes(filter).notes.map(&:guid)
        # TODO: assign the booleans
        en_notes = note_guids.map { |note_guid| note_store.getNote(developer_token, note_guid, true, true, false, false) }
        en_notes.each do |en_note|
          note = Note.new(title: en_note.title, content: en_note.content, notebook_guid: en_note.notebookGuid)
          puts "importing #{find_notebook_by_guid_from_notebook_list(notebook_list, note).title}"
          notebook_list.each do |list|
            # TODO: break if note not found
            CsonGenerator.output(list.hash, note, output_dir) if list.guid == note.notebook_guid
          end
        end
      end
      puts "\e[32mSuccessfully finished!\e[0m"
      puts "\e[32mImported notes are located at #{output_dir}, mount it to Boostnote!\e[0m"
    rescue => e
      abort_with_message e
    end

    def abort_with_message(exception)
      if exception.class == Evernote::EDAM::Error::EDAMUserException
        abort "\e[31mError! Confirm your developer token.\e[0m"
      elsif exception.class == Evernote::EDAM::Error::EDAMSystemException
        abort "\e[31mError! You reached EvernoteAPI rate limitation.\nThe notes processed so far have been created successfully.\nMore information: https://github.com/BoostIO/ever2boost/tree/master/docs/Api_error.md\e[0m"
      else
        raise exception
      end
    end

    def find_notebook_by_guid_from_notebook_list(notebook_list, note)
      notebook_list.map do |nl|
        nl if note.notebook_guid == nl.guid
      end.compact.first
    end
  end
end
