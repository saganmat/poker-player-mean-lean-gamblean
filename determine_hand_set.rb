
class DetermineHandSet
  def initialize(cards)
    @cards = cards
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
end