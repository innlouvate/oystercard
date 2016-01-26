require_relative 'station'
require_relative 'journey'

class Oystercard

  attr_reader :balance, :journey_list, :entry_station, :current_journey
  BALANCE_MAX = 90
  FARE_MIN = 1
  def initialize(journey_class = Journey)
    @balance = 0
    @journey_list = []
    @journey_class = journey_class
  end

  def top_up(value)
    raise 'Top-up exceeds maximum limit of #{BALANCE_MAX}' if @balance + value > BALANCE_MAX
    @balance += value
  end

  def touch_in(station)
    raise 'Please top up your card.' if @balance < FARE_MIN
    # @entry_station = station
    @current_journey = @journey_class.new(station)
  end

  def touch_out(station)
    deduct(FARE_MIN)
    @current_journey.exit(station)
    journey_capture(station)
    # @entry_station = nil
  end
  #


  private

  def deduct(value)
    @balance -= value
  end

  def journey_capture(exitstation)
    journey = { @entry_station => exitstation }
     @journey_list << journey
  end
end
