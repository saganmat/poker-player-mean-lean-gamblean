require_relative "determine_hand_set"
require_relative "determine_possible_hand_set"
require_relative "make_play"
require_relative "card"
class Player

  VERSION = "v0.3.1"

  def bet_request(game_state)

		current_player = game_state["players"][game_state["in_action"]]
    current_hole_cards = current_player["hole_cards"]
    community_cards = game_state["community_cards"]

    current_combination = current_hole_cards + community_cards
    hand_set = ::DetermineHandSet.new(current_combination).call

    raise_amount = if current_player["stack"] >= game_state["minimum_raise"]
      game_state["minimum_raise"]
    else
      current_player["stack"]
    end

		bet_increment = 2 * game_state["minimum_raise"]

		if current_combination.count < 7
			::MakePlay.new(
				action: "call",
				current_funds: current_player["stack"],
				current_buy_in: game_state["current_buy_in"],
				current_bet: current_player["bet"]
			).call
		else
			if hand_set.pair
				::MakePlay.new(
					action: "raise",
					current_funds: current_player["stack"],
					current_buy_in: game_state["current_buy_in"],
					current_bet: current_player["bet"],
					raise_amount: raise_amount
				).call
			elsif hand_set.two_pairs || hand_set.three_of_a_kind || hand_set.flush
				::MakePlay.new(
					action: "raise",
					current_funds: current_player["stack"],
					current_buy_in: game_state["current_buy_in"],
					current_bet: current_player["bet"],
					raise_amount: raise_amount + bet_increment
				).call
			elsif hand_set.four_of_a_kind
				::MakePlay.new(
					action: "raise",
					current_funds: current_player["stack"],
					current_buy_in: game_state["current_buy_in"],
					current_bet: current_player["bet"],
					raise_amount: raise_amount + (bet_increment * 2)
				).call
			else
				::MakePlay.new(
					action: "fold",
					current_funds: current_player["stack"],
					current_buy_in: game_state["current_buy_in"],
					current_bet: current_player["bet"],
					raise_amount: raise_amount
				).call
			end
		end
	end

  def showdown(game_state)
  end
end
