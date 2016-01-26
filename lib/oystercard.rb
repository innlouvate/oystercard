class Oystercard

  attr_reader :balance
  BALANCE_MAX = 90
  FARE_MIN = 1

  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(value)
    max_balance = BALANCE_MAX
    raise 'Top-up exceeds maximum limit of #{BALANCE_MAX}' if @balance + value > BALANCE_MAX
    @balance += value
  end

  def touch_in
    raise 'Please top up your card.' if @balance < FARE_MIN
    @in_use = true
  end

  def touch_out
    deduct(FARE_MIN)
    @in_use = false
  end

  def in_journey?
    @in_use
  end

  private

  def deduct(value)
    @balance -= value
  end


end
