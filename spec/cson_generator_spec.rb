require 'spec_helper'
require 'ever2boost/note'
require 'ever2boost/cson_generator'

describe Ever2boost::CsonGenerator do
  let (:folder_hash) { '0123abcdef' }
  let (:title) { 'lorem' }
  let (:content) { "<en-note>lorem ipsum</en-note>" }
  let (:note) { Ever2boost::Note.new(title: title, content: content) }
  let (:md_note_content) { Ever2boost::MdConverter.convert(note.content) }
  let (:timestamp) { Ever2boost::CsonGenerator.timestamp }

  let (:cson) {
<<-EOS
type: "MARKDOWN_NOTE"
folder: "#{folder_hash}"
title: "#{note.title}"
content: '''
  # #{note.title}
  #{md_note_content}
'''
tags: []
isStarred: false
createdAt: "#{timestamp}"
updatedAt: "#{timestamp}"
EOS
  }

  describe '#build' do
    it 'should return a cson' do
      expect(Ever2boost::CsonGenerator.build(folder_hash, note)).to eq(cson)
    end
  end
end
