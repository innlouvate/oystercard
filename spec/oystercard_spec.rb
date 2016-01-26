require 'oystercard'

describe Oystercard do
  subject(:oystercard) {described_class.new}
  let(:station) { double :station }

  describe "#balance" do
    it "is initialised with a balance of 0 by default" do
      expect(oystercard.balance).to eq 0
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


  describe '#touch_in' do
    # xit 'sets the oystercard to being in journey' do
    #   oystercard.top_up(Oystercard::FARE_MIN)
    #   expect(oystercard.touch_in(station)).to eq true
    # end

    it 'raises an exception if the balance is inferior to £1' do
      expect{ oystercard.touch_in(station) }.to raise_error 'Please top up your card.'
    end

    it 'when touched in logs entry station' do
      oystercard.top_up(Oystercard::FARE_MIN)
      oystercard.touch_in(station)
      expect(oystercard.entry_station).to eq station
    end
  end

  describe '#touch_out' do
    # xit 'sets the oystercard to being off journey' do
    #   expect(oystercard.touch_out).to eq false
    # end

    it 'reduces the balance by the minimum fare' do
      expect{ oystercard.touch_out(station) }.to change { oystercard.balance }.by(-Oystercard::FARE_MIN)
    end

    it 'when touched out removes entry station' do
      oystercard.top_up(Oystercard::FARE_MIN)
      oystercard.touch_in(station)
      oystercard.touch_out(station)
      expect(oystercard.entry_station).to eq nil
    end
  end

  describe '#in_journey?' do
    it 'checks that when initialised the card is not in journey' do
      expect(oystercard).to_not be_in_journey
    end
  end

  describe 'Journey capture hash' do
    it 'expects touch in station to become key in hash' do
      expect(oystercard).to receive(:journey_capture)
      oystercard.touch_out(station)
    end
  end

  describe 'initialize' do
    it 'includes empty journey_list' do
      expect(oystercard.journey_list).to eq []
    end
  end

  describe 'journey created' do
    it 'touching in and out creates one journey' do
      oystercard.top_up(Oystercard::FARE_MIN)
      oystercard.touch_in(station)
      oystercard.touch_out(station)
      expect(oystercard.journey_list).to include(station => station)
    end
  end
end
