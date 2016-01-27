
class JourneyLog



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
    @current_journey = @journey_klass.new(station)
  end

  def exit_journey(station)
    # add exit station to current_journey
    # @current_journey.exit(station)
    outstanding_charges(station)
    log_current_journey
  end

  def outstanding_charges(station)
    # close incomplete journey & return fare
    if @current_journey == nil
      @current_journey = @journey_klass.new(nil)
    end
    @current_journey.exit(station)
    @current_journey.fare
  end

  private

  def current_journey
    @current_journey = @journey_klass.new(nil) if @current_journey == nil
    @current_journey
    # private - return incomplete journey or create new journey
  end

  def reset_journey
    @current_journey = nil
  end

  def log_current_journey
    @journey_log << @current_journey
    reset_journey
  end

end
