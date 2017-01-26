require 'spec_helper'
require 'fileutils'

describe Ever2boost::EnexConverter do
  let(:enex) { File.read('spec/lorem.enex') }
  let(:output_dir) { 'spec/dist/evernote_storage' }
  let(:filename) { 'lorem' }
  let(:cson_folder_hash) do
    cson_filename = `ls spec/dist/evernote_storage/notes`.lines.first.chomp
    File.read("#{output_dir}/notes/#{cson_filename}").lines[1].chomp.slice(/[a-f0-9]{12}/)
  end
  let(:json_folder_hash) do
    json = File.read("#{output_dir}/boostnote.json")
    JSON.parse(json)['folders'].first["key"]
  end

  describe '#convert' do
    before do
      Ever2boost::EnexConverter.convert(enex, output_dir, filename)
    end

    after do
      FileUtils.rm_r(output_dir)
    end

    it 'should generate boostnote.json' do
      expect(File.exist?("#{output_dir}/boostnote.json")).to be_truthy
    end

    it 'should generate notes/*.cson' do
      expect(File.exist?("#{output_dir}/notes")).to be_truthy
    end

    it 'generate a note which has correct folder hash' do
      expect(cson_folder_hash).to eq(json_folder_hash)
    end
  end
end
