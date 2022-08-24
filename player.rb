require_relative "determine_hand_set"
require_relative "determine_possible_hand_set"
require_relative "make_play"
require_relative "card"
class Player

  VERSION = "v0.4.1"

  def bet_request(game_state)

    current_player = game_state["players"][game_state["in_action"]]
    current_hole_cards = current_player["hole_cards"]
    community_cards = game_state["community_cards"]
    current_combination = []

    current_hole_cards.each do |card|
      current_combination << Card.new(rank: card["rank"], suit: card["suit"])
    end

    community_cards.each do |card|
      current_combination << Card.new(rank: card["rank"], suit: card["suit"])
    end

    hand_set = ::DetermineHandSet.new(current_combination)

    raise_amount = if current_player["stack"] >= game_state["minimum_raise"]
      game_state["minimum_raise"]
    else
      current_player["stack"]
    end

		if current_combination.count < 7
			::MakePlay.new(
				action: "call",
				current_funds: current_player["stack"],
				current_buy_in: game_state["current_buy_in"],
				current_bet: current_player["bet"],
				raise_amount: 0
			).call
		else
			highest_competitor_danger_points = 0
			game_state["players"].each do |player|
        next unless player["hole_cards"].present?
        competitor_hand = []

        player["hole_cards"].each do |card|
          competitor_hand << Card.new(rank: card["rank"], suit: card["suit"])
        end

				competitor_hand_set = ::DetermineHandSet.new(competitor_hand)
				if competitor_hand_set.danger_points > highest_competitor_danger_points
					highest_competitor_danger_points = competitor_hand_set.danger_points
				end
			end

			if hand_set.danger_points > highest_competitor_danger_points
				bet_increment = game_state["minimum_raise"] + (game_state["minimum_raise"] * (danger_points * 0.1)).ceil
				::MakePlay.new(
					action: "raise",
					current_funds: current_player["stack"],
					current_buy_in: game_state["current_buy_in"],
					current_bet: current_player["bet"],
					raise_amount: raise_amount + bet_increment
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
