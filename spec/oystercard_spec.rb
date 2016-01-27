require 'oystercard'

describe Oystercard do
  # subject(:oystercard) {described_class.new(journey_klass)}
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  let(:class_double) { double :class_double }
  # let(:my_journey) {double :class_double.new(entry_station) }
  subject(:oystercard) { described_class.new(class_double) }

  before do
    allow(class_double).to receive(:new).and_return(:my_journey)
    # allow(journey).to receive(:exit)
  end

  context 'card is initialised' do
    describe "#balance" do
      it "is initialised with a balance of 0 by default" do
        expect(oystercard.balance).to eq 0
      end
    end

    describe '#touch_in' do
      it 'raises an exception if the balance is less than min journey price' do
        expect{ oystercard.touch_in(entry_station) }.to raise_error 'Please top up your card.'
      end
    end

    # describe '#in_journey?' do
    #   it 'checks that when initialised the card is not in journey' do
    #     expect(oystercard).to_not be_in_journey
    #   end
    # end

    describe '#journey_list' do
      it 'includes empty journey_list' do
        expect(oystercard.journey_list).to eq []
      end
    end
  end

  describe '#top_up' do
    it 'adds the value specified to the balance' do
      value = rand(Oystercard::BALANCE_MAX)
      expect{oystercard.top_up(value)}.to change{ oystercard.balance }.from(0).to(value)
    end

    it 'raises an error if topping up more than the max limit' do
      oystercard.top_up(Oystercard::BALANCE_MAX)
      expect{ oystercard.top_up(1) }.to raise_error{'Top-up exceeds maximum limit of #{Oystercard::BALANCE_MAX}'}
    end
  end

  context 'starting a new journey' do
    before do
      oystercard.top_up(Oystercard::FARE_MIN)
    end

    describe '#touch_in' do
      it 'when touched in journey is initialised' do
        # card = described_class.new(class_double)
        # card.top_up(10)
        expect(class_double).to receive(:new)
        oystercard.touch_in(entry_station)
      end
    end
  end

  context 'finishing your first journey' do
    before do
      oystercard.top_up(Oystercard::FARE_MIN)
      oystercard.touch_in(entry_station)
    end

    describe '#touch_out' do
      it 'reduces the balance by the minimum fare' do
        expect{ oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by(-Oystercard::FARE_MIN)
      end

      it 'calls exit method on the current journey' do
        expect(class_double).to receive(:exit)
        oystercard.touch_out(exit_station)
      end
    end

    describe 'Journey capture hash' do
      xit 'expects touch in station to become key in hash' do
        expect(oystercard).to receive(:journey_capture)
        oystercard.touch_out(exit_station)
      end
    end

    describe 'journey created' do
      xit 'touching in and out creates one journey' do
        oystercard.top_up(Oystercard::FARE_MIN)
        oystercard.touch_in(entry_station)
        oystercard.touch_out(exit_station)
        expect(oystercard.journey_list).to include(entry_station => exit_station)
      end
    end
  end
end
