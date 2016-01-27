require 'forwardable'

class JourneyLog

  extend Forwardable

  def_delegator :current_journey, :exit, :exit_journey

  def initialize(journey_klass = Journey)
    # inject jouney class
    @journey_klass = journey_klass
    @journey_log = []
  end

  def view_log
    @journey_log.dup
  end

  def start_journey(station)
    # logs entry station
    # raise 'Already in journey' if current_journey.entry_station
    log(journey_klass.new(entry_station: station))
  end

  def outstanding_charges(station)
    # close incomplete journey & return fare
    incomplete_journey ? incomplete_journey.exit.fare : 0
  end

  private
  attr_reader :journey_klass

  def incomplete_journey
    @journey_log.reject(&:complete_journey?).first
  end

  def current_journey
    incomplete_journey || journey_klass.new
    # private - return incomplete journey or create new journey
  end
  #
  # def reset_journey
  #   @current_journey = nil
  # end

  def log(journey)
    @journey_log << journey
  end

end
