require_relative 'oystercard'
require_relative 'station'

class Journey
  attr_reader :entry_station, :exit_station
  FARE_MIN = 1
  PENALTY_FARE = 6

  def initialize(entry_station)
    @entry_station = entry_station
  end

  def exit(exit_station)
    @exit_station = exit_station
    self
  end

  def complete_journey?
    @entry_station == nil || @exit_station == nil ? false : true
  end

  def fare
    complete_journey? ? FARE_MIN : PENALTY_FARE
  end

end
