require_relative 'oystercard'
require_relative 'station'

class Journey
  attr_reader :entry_station, :exit_station
  FARE_MIN = 1
  PENALTY_FARE = 6

  def initialize(entry_station = nil)
    @entry_station = entry_station
    @complete = false
  end

  def exit(exit_station = nil)
    @exit_station = exit_station
    @complete = true
    self
  end

  def complete_journey?
    @complete
  end

  def fare
    complete_journey? ? FARE_MIN : PENALTY_FARE
  end

end
