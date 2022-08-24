class Card
  ORDER = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  attr_reader :rank, :suit

  def initialize(rank:, suit:)
    @rank = rank
    @suit = suit
  end

  def <=> (card)
    ORDER.find_index(self.rank) <=> ORDER.find_index(card.rank)
  end

  def > (card)
    ORDER.find_index(self.rank) > ORDER.find_index(card.rank)
  end

  def == (card)
    ORDER.find_index(self.rank) > ORDER.find_index(card.rank)
  end

  def < (card)
    ORDER.find_index(self.rank) < ORDER.find_index(card.rank)
  end

  def distance_from(card)
    (ORDER.find_index(self.rank) - ORDER.find_index(card.rank)).abs
  end

end