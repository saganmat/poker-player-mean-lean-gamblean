class MakePlay

  def initialize(action:, current_funds:, current_buy_in:, current_bet:, raise_amount:)
    @action = action
    @current_funds = current_funds
    @current_buy_in = current_buy_in
    @current_bet = current_bet
    @raise_amount = raise_amount
  end
  def call
    case @action
    when "fold"
      0
    when "call"
      @current_buy_in - @current_bet
    when "raise"
      @current_buy_in - @current_bet + @raise_amount
    else
      0
    end
  end
end