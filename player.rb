require_relative "determine_hand_set"
require_relative "determine_possible_hand_set"
class Player

  VERSION = "v0.1.2"

  def bet_request(game_state)
    current_player = game_state["players"].filter { |player| player["name"].eql?("Mean Lean Gamblean") }.first
    current_hole_cards = current_player["hole_cards"]
    community_cards = game_state["community_cards"]

    current_combination = current_hole_cards + community_cards
    hand_set = ::DetermineHandSet.new(current_combination).call

    0
  end

  def showdown(game_state)

  end
end
