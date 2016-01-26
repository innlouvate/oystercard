require_relative 'oystercard'

class Journey
  attr_reader :entry_station

  def initialize(entry_station)
    @entry_station = entry_station
  end

  def exit(exit_station)
    @exit_station = exit_station
    self
  end

  def complete_journey?
    @complete_journey = false
  end
end
