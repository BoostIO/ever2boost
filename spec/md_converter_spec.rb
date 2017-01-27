require 'spec_helper'

describe Ever2boost::MdConverter do
  let (:note_content) { '<en-note>lorem ipsum</en-note>' }

  describe '#convert' do
    it 'should return md style string' do
      expect(Ever2boost::MdConverter.convert(note_content)).to eq('lorem ipsum')
    end
  end
end
