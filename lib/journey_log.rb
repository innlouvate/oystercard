require './lib/oystercard.rb'
require './lib/station.rb'
require './lib/journey.rb'

class JourneyLog 

  attr_reader :current_journey

  def initialize(journey_klass = Journey)
    @journey_hist = []
    @journey_klass = journey_klass
    @current_journey = nil
  end

  def journey_hist
    @journey_hist.clone
  end

  def start_journey(entry_station)
    record_log(new_journey(entry_station))
  end

  def end_journey(exit_station)
    @current_journey.record_exit(exit_station)
  end

  def reset
    @current_journey = nil
  end

  # def current_journey(current_station)
  #   incomplete_journey? ? @current_journey :
  #   @current_journey = new_journey
  # end

  def outstanding_charges
     @current_journey.fare
  end

  def record_log(journey)
    @journey_hist << journey
  end

  def incomplete_journey?
    @current_journey.incomplete?
  end

  def new_journey(entry_station)
    @current_journey = @journey_klass.new(entry_station)
  end

end
