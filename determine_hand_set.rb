class DetermineHandSet
  def initialize(cards)
    @cards = cards.sort!
  end

  def call
    @cards
    # It should return an array like
    # [
    # { "pair" => [{"suit" => "hearts", "rank" => "7"}, {"suit" => "spades", "rank" => "7"}] }
    # { "flush" => [{"suit" => "hearts", "rank" => "7"}, {"suit" => "spades", "rank" => "7"}] }
    #
    #
    #
    #
    #
    # ]
  end

  def pair?
    @cards.collect {|c| c.rank}.tally.any? {|k, v| v == 2}
  end

  def two_pairs?
    return false if three_of_a_kind?

    @cards.collect {|c| c.rank}.tally.filter {|k, v| v == 2}.count >= 2
  end

  def three_of_a_kind?
    return false if four_of_a_kind?

    @cards.collect {|c| c.rank}.tally.any? {|k, v| v == 3}
  end

  def four_of_a_kind?
    @cards.collect {|c| c.rank}.tally.any? {|k, v| v == 4}
  end

  def flush?
    @cards.collect { |c| c.suit}.tally.any? {|k, v| v == 5 }
  end

  def straight?
    
  end

  def full_house?
    ranks = @cards.collect { |c| c.rank}.tally
    potential_threes = ranks.filter { |k, v| v >= 3 }
    if potential_threes.any?
      ranks_of_threes = potential_threes.map{|k,v| k}
      potential_twos = ranks.filter { |k, v| v >= 2 && !ranks_of_threes.include(k) }
      potential_twos.any?
    else
      false
    end
  end
end