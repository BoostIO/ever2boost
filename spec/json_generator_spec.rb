require 'spec_helper'

describe Ever2boost::JsonGenerator do
  let (:notelist1) { Ever2boost::NoteList.new(title: 'title1', guid: '012345abcdef')}
  let (:notelist2) { Ever2boost::NoteList.new(title: 'title2', guid: '0123456abcde')}
  let (:notebook_list) { [notelist1, notelist2] }
  let (:json) do
<<-EOS
{
  "folders": [
    {
      "key": "012345abcdef",
      "name": "title1",
      "color": "#E10051"
    },
    {
      "key": "0123456abcde",
      "name": "title2",
      "color": "#E10051"
    }
  ],
  "version": "1.0"
}
EOS
  end

  describe '#build' do
    before do
      notelist1.hash = '012345abcdef'
      notelist2.hash = '0123456abcde'
      notelist1.color = '#E10051'
      notelist2.color = '#E10051'
    end

    it 'should return a json' do
      expect(Ever2boost::JsonGenerator.build(notebook_list)).to eq(json)
    end
  end
end
