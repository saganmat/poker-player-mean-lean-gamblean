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

	def high_card?
		@cards.none?{ |c| (%w[J Q K A 10]).include?(c["rank"]) }
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
    counter = 0
    @cards.each_with_index do |card, index|
      break if counter == 4
      break if index == @cards.count - 1
      next_card = @cards[index+1]
      distance_from_next_card = card.distance_from(next_card)

      p "#{card.rank} is #{distance_from_next_card} away from #{next_card.rank}"

      if distance_from_next_card == 1
        counter += 1
      else
        counter = 0
      end
    end
    counter == 5
  end

  def straight_flush?
    counter = 0
    @cards.each_with_index do |card, index|
      break if counter == 4
      break if index == @cards.count - 1

      next_card = @cards[index+1]
      distance_from_next_card = card.distance_from(next_card)

      p "#{card.rank} is #{distance_from_next_card} away from #{next_card.rank}"

      if distance_from_next_card == 1 && card.suit.eql?(next_card.suit)
        counter += 1
      else
        counter = 0
      end
    end
    counter == 4
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

	def danger_points
		# if royal? 7
		if straight_flush?
      9
		elsif four_of_a_kind?
      8
		elsif full_house?
      7
		elsif flush?
      6
		elsif straight?
      5
		elsif three_of_a_kind?
      4
		elsif two_pairs?
      3
		elsif pair?
      2
		elsif high_card?
      1
		end
		0
	end
end