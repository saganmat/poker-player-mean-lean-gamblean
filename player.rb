require_relative "determine_hand_set"
require_relative "determine_possible_hand_set"
require_relative "make_play"
class Player

  VERSION = "v0.2"

  def bet_request(game_state)
    current_player = game_state["players"][game_state["in_action"]]
    current_hole_cards = current_player["hole_cards"]
    community_cards = game_state["community_cards"]

    current_combination = current_hole_cards + community_cards
    hand_set = ::DetermineHandSet.new(current_combination).call

    MakePlay.call(
      action: "call",
      current_buy_in: game_state["current_buy_in"],
      current_bet: current_player["bet"],
      raise: game_state["minimum_raise"]
    )
  end

  def showdown(game_state)

  end
end
