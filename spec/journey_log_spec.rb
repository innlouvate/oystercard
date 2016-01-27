require 'journey_log'

describe JourneyLog do
  # subject(:oystercard) {described_class.new(journey_klass)}
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  let(:journey_klass) { double :journey_klass, new: journey}
  let(:journey) { double :journey, complete_journey?: false, fare: Journey::FARE_MIN }
  subject(:journeylog) { described_class.new(journey_klass) }

  before do
    # allow(journey_klass).to receive(:new).and_return(current_journey)
    allow(journey).to receive(:exit).and_return(journey)
    allow(journey).to receive(:entry_station)
    allow(journey_klass).to receive(:new).and_return(journey)
    # allow(journey).to receive(:fare).and_return(Journey::FARE_MIN)
  end

  context 'initialising the log' do
    describe '#initialised' do
      it 'should have an empty log array' do
        expect(journeylog.view_log).to eq []
      end
    end

  end

  context 'starting a new journey' do
    # before do
    #   oystercard.top_up(Journey::FARE_MIN)
    # end

    describe '#start_journey' do
      it 'start creates new journey instance' do
        expect(journey_klass).to receive(:new).with(entry_station: entry_station)
        journeylog.start_journey(entry_station)
      end
      it 'records a new journey' do
        journeylog.start_journey(entry_station)
        expect(journeylog.view_log).to include(journey)
      end
    end
  end


  context 'finishing the first journey' do
    describe '#exit_journey' do
      it 'calls exit method on the current journey' do
        journeylog.start_journey(entry_station)
        expect(journey).to receive(:exit)
        journeylog.exit_journey(exit_station)
      end

      # it 'expects journey to be logged' do
      #   journeylog.exit_journey(exit_station)
      #   expect(journeylog.view_log).to include journey
      # end

      it 'create a journey if one did not exist' do 
        expect(journey_klass).to receive(:new)
        journeylog.exit_journey(exit_station)
      end
    end
  end

  describe '#outstanding_charges' do
    context 'incomplete journey' do
      it 'should end an incomplete journey' do
        journeylog.start_journey(entry_station)
        expect(journey).to receive(:exit)
        journeylog.outstanding_charges(exit_station)
      end
      it 'returns the basic fare amount' do
        journeylog.start_journey(entry_station)
        expect(journeylog.outstanding_charges(exit_station)).to eq(Journey::FARE_MIN)
      end
    end
    context 'complete journey' do
      it 'returns 0 amount' do
        allow(journey).to receive(:complete_journey?).and_return(true)
        journeylog.start_journey(entry_station)
        journeylog.exit_journey(exit_station)
        expect(journeylog.outstanding_charges(exit_station)).to eq(0)
      end
    end
  end

end
