require 'journey_log'

describe JourneyLog do
  # subject(:oystercard) {described_class.new(journey_klass)}
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  let(:class_double) { double :class_double }
  let(:current_journey) { double :current_journey }
  subject(:journeylog) { described_class.new(class_double) }

  before do
    allow(class_double).to receive(:new).and_return(current_journey)
    # allow(my_journey).to receive(:start_journey)
    allow(current_journey).to receive(:exit)
    allow(current_journey).to receive(:fare).and_return(Journey::FARE_MIN)
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
        expect(class_double).to receive(:new).with entry_station
        journeylog.start_journey(entry_station)
      end
    end
  end


  context 'finishing the first journey' do
    before do
      # oystercard.top_up(Journey::FARE_MIN)
      journeylog.start_journey(entry_station)
    end

    describe '#exit_journey' do
      it 'calls exit method on the current journey' do
        expect(current_journey).to receive(:exit)
        journeylog.exit_journey(exit_station)
      end

      it 'expects journey to be logged' do
        journeylog.exit_journey(exit_station)
        expect(journeylog.view_log).to include current_journey
      end
    end
  end

  describe '#outstanding_charges' do
    context 'incomplete journey' do
      it 'should create a new journey' do
        # allow(current_journey).to receive(:complete_journey?).and_return(false)
        expect(class_double).to receive(:new).with nil
        journeylog.outstanding_charges(exit_station)
      end
    end
    context 'complete journey' do
      before do
        # allow(current_journey).to receive(:complete_journey?).and_return(true)
        journeylog.start_journey(entry_station)
      end
      it 'returns the basic fare amount' do
        expect(journeylog.outstanding_charges(exit_station)).to eq(Journey::FARE_MIN)
      end
    end
  end

end
