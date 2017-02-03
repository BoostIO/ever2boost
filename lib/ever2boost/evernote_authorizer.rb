require 'evernote-thrift'
require 'ever2boost/note'
require 'ever2boost/note_list'
require 'ever2boost/util'

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

      warn Util.yellow_output("Ignore first #{(number_of_note - 250)} notes due to EvernoteAPI access limitation in this notebook.") if number_of_note > 250
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

      notebook_guids.map do |notebook_guid|
        filter = Evernote::EDAM::NoteStore::NoteFilter.new(notebookGuid: notebook_guid)
        note_guids = fetch_notes(filter).notes.map(&:guid)
        puts "importing #{note_store.getNotebook(developer_token, notebook_guid).name}"
        # TODO: assign the booleans
        en_notes = note_guids.map { |note_guid| note_store.getNote(developer_token, note_guid, true, true, true, false) }
        en_notes.each do |en_note|
          download_image(en_note, output_dir) unless en_note.resources.nil?
          note = Note.new(title: en_note.title, content: en_note.content, notebook_guid: en_note.notebookGuid, output_dir: output_dir)
          # puts "importing #{find_notebook_by_guid_from_notebook_list(notebook_list, note).title}"
          notebook_list.each do |list|
            # TODO: break if note not found
            CsonGenerator.output(list.hash, note, output_dir) if list.guid == note.notebook_guid
          end
        end
      end
      puts Util.green_output('Successfully finished!')
      puts Util.green_output("Imported notes are located at #{output_dir}, mount it to Boostnote!")
    rescue => e
      abort_with_message e
    end

    def abort_with_message(exception)
      if exception.class == Evernote::EDAM::Error::EDAMUserException
        abort Util.red_output('Error! Confirm your developer token.')
      elsif exception.class == Evernote::EDAM::Error::EDAMSystemException
        abort Util.red_output("Error! You reached EvernoteAPI rate limitation.\nThe notes processed so far have been created successfully.\nMore information: https://github.com/BoostIO/ever2boost/tree/master/docs/api_error.md")
      else
        raise exception
      end
    end

    def find_notebook_by_guid_from_notebook_list(notebook_list, note)
      notebook_list.map do |nl|
        nl if note.notebook_guid == nl.guid
      end.compact.first
    end

    # TODO: handle to not image file
    def download_image(en_note, output_dir)
      en_note.resources.each do |resource|
        imagename = resource.data.bodyHash.unpack("H*").first
        extension = resource.mime.gsub(/(.+?)\//, '')
        Util.make_images_dir(output_dir)
        File.open("#{output_dir}/images/#{imagename}.#{extension}", 'w+b' ) do |f|
          f.write note_store.getResourceData(developer_token, resource.guid)
        end
      end
    end
  end
end
