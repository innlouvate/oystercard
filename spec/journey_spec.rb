require 'journey'

describe Journey do
  subject(:journey) {described_class.new(entry_station)}
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  let(:oystercard)  { double :oystercard}

  describe 'creates new journey' do
    it 'should have an entry station' do
      expect(journey.entry_station).to be_truthy
    end
  end

  describe 'journey complete' do
    it 'checks journey is not complete' do
      expect(journey.complete_journey?).to eq false
    end
  end

  describe 'exit' do
    it 'returns itself' do
      expect(journey.exit(exit_station)).to eq journey
    end
  end

end
