require_relative "determine_hand_set"
require_relative "determine_possible_hand_set"
require_relative "make_play"
require_relative "card"
class Player

  VERSION = "v0.5.GREEDY"

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

		if current_combination.count < 5
			::MakePlay.new(
				action: "call",
				current_funds: current_player["stack"],
				current_buy_in: game_state["current_buy_in"],
				current_bet: current_player["bet"],
				raise_amount: 0
			).call
		elsif current_combination.count == 2 && hand_set.danger_points == 2
      bet_increment = 50

      ::MakePlay.new(
				action: "raise",
				current_funds: current_player["stack"],
				current_buy_in: game_state["current_buy_in"],
				current_bet: current_player["bet"],
				raise_amount: raise_amount + bet_increment
			).call
		elsif current_combination.count == 5 && hand_set.danger_points < 2
			::MakePlay.new(
				action: "fold",
				current_funds: current_player["stack"],
				current_buy_in: game_state["current_buy_in"],
				current_bet: current_player["bet"],
				raise_amount: 0
			).call
		elsif current_combination.count <= 7
			highest_competitor_danger_points = 0
			game_state["players"].each do |player|
        next if player["hole_cards"].nil?
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
				danger_offset = hand_set.danger_points - highest_competitor_danger_points
				if(danger_offset > 3)
					bet_increment = game_state["minimum_raise"] + (game_state["minimum_raise"] * (danger_offset)).ceil
					::MakePlay.new(
						action: "raise",
						current_funds: current_player["stack"],
						current_buy_in: game_state["current_buy_in"],
						current_bet: current_player["bet"],
						raise_amount: raise_amount + bet_increment
					).call
				elsif(danger_offset <= 0)
					::MakePlay.new(
						action: "fold",
						current_funds: current_player["stack"],
						current_buy_in: game_state["current_buy_in"],
						current_bet: current_player["bet"],
						raise_amount: raise_amount
					).call
				else
					bet_increment = game_state["minimum_raise"] + (game_state["minimum_raise"] * (danger_points * 0.5)).ceil
					::MakePlay.new(
						action: "raise",
						current_funds: current_player["stack"],
						current_buy_in: game_state["current_buy_in"],
						current_bet: current_player["bet"],
						raise_amount: raise_amount + bet_increment
					).call
				end
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
