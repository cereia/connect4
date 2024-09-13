# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/board'
require_relative '../lib/game'

# rubocop:disable Metrics/BlockLength

describe Game do
  describe '#play_game' do
    subject(:game_play_game) { described_class.new }

    context 'when a user inputs a valid yes input' do
      before do
        yes_input = 'y'
        allow(game_play_game).to receive(:player_answer).and_return(yes_input)
      end

      it 'creates a new Board object' do
        expect(Board).to receive(:new)
        game_play_game.play_game
      end

      it 'calls #create_players once' do
        expect(game_play_game).to receive(:create_players).once
        game_play_game.play_game
      end
    end

    context 'when a user inputs a valid no input' do
      before do
        no_input = 'n'
        allow(game_play_game).to receive(:player_answer).and_return(no_input)
      end

      it 'puts a message to the console and exits' do
        no_message = 'Thank you for checking out the game :)'
        expect(game_play_game).to receive(:puts).with(no_message)
        game_play_game.play_game
      end
    end
  end

  describe '#player_answer' do
    subject(:game_player_answer) { described_class.new }

    context 'when a user inputs a valid input' do
      before do
        valid_input = 'N'
        allow(game_player_answer).to receive(:player_answer_input).and_return(valid_input)
      end

      it 'returns valid input' do
        answer = game_player_answer.player_answer
        expect(answer).to eq('N')
      end

      it 'stops the loop and does not display an error message' do
        invalid_message = 'Invalid input. Please enter (Y/N).'
        expect(game_player_answer).not_to receive(:puts).with(invalid_message)
        game_player_answer.player_answer
      end
    end

    context 'when a user inputs an invalid answer and a valid one' do
      before do
        invalid_input = 'x'
        valid_input = 'n'
        allow(game_player_answer).to receive(:player_answer_input).and_return(invalid_input, valid_input)
      end

      it 'completes one loop and an error message is shown' do
        invalid_message = 'Invalid input. Please enter (Y/N).'
        expect(game_player_answer).to receive(:puts).with(invalid_message).once
        game_player_answer.player_answer
      end
    end

    context 'when a user inputs 2 invalid inputs and a valid one' do
      before do
        invalid1 = '@'
        invalid2 = '234'
        valid_input = 'n'
        allow(game_player_answer).to receive(:player_answer_input).and_return(invalid1, invalid2, valid_input)
      end

      it 'completes two loops and displays an error message twice' do
        invalid_message = 'Invalid input. Please enter (Y/N).'
        expect(game_player_answer).to receive(:puts).with(invalid_message).twice
        game_player_answer.player_answer
      end
    end
  end

  describe '#verify_player_answer' do
    subject(:game_verify_answer) { described_class.new }

    context 'when user input is valid' do
      it 'returns a valid input' do
        user_input = 'n'
        verified_input = game_verify_answer.verify_player_answer(user_input)
        expect(verified_input).to eq('n')
      end
    end

    context 'when user input is invalid' do
      it 'returns nil' do
        user_input = '3'
        verified_input = game_verify_answer.verify_player_answer(user_input)
        expect(verified_input).to be_nil
      end
    end
  end

  describe '#create_players' do
    subject(:game_create_players) { described_class.new }

    before do
      red_input = 'r'
      allow(game_create_players).to receive(:player_color).and_return(red_input)
    end

    it 'creates two new Player instances' do
      expect(Player).to receive(:new).twice
      game_create_players.create_players
    end
  end

  describe '#player_color' do
    subject(:game_player_color) { described_class.new }

    context 'when a user input is valid' do
      before do
        valid_input = 'red'
        allow(game_player_color).to receive(:player_color_input).and_return(valid_input)
      end

      it 'returns valid input' do
        color = game_player_color.player_color
        expect(color).to eq('r')
      end

      it 'stops the loop and does not display an error message' do
        invalid_message = 'Invalid input. Please enter (R/B).'
        expect(game_player_color).not_to receive(:puts).with(invalid_message)
        game_player_color.player_color
      end
    end

    context 'when a user inputs an invalid and a valid input' do
      before do
        invalid_input = ')'
        valid_input = 'b'
        allow(game_player_color).to receive(:player_color_input).and_return(invalid_input, valid_input)
      end

      it 'completes a loop and displays an error message' do
        invalid_message = 'Invalid input. Please enter (R/B).'
        expect(game_player_color).to receive(:puts).with(invalid_message).once
        game_player_color.player_color
      end
    end

    context 'when a user inputs 3 invalid and one valid input' do
      before do
        invalid1 = '<'
        invalid2 = '34'
        invalid3 = 'we'
        valid = 'R'
        allow(game_player_color).to receive(:player_color_input).and_return(invalid1, invalid2, invalid3, valid)
      end

      it 'completes 3 loops and displays error message 3 times' do
        invalid_message = 'Invalid input. Please enter (R/B).'
        expect(game_player_color).to receive(:puts).with(invalid_message).exactly(3).times
        game_player_color.player_color
      end
    end
  end

  describe '#verify_player_color' do
    subject(:game_verify_color) { described_class.new }

    context 'when user input is valid' do
      it 'returns valid input' do
        valid_color = 'RE'
        verified_color = game_verify_color.verify_player_color(valid_color)
        expect(verified_color).to eq('R')
      end

      it 'returns valid input' do
        valid_color = 'blu'
        verified_color = game_verify_color.verify_player_color(valid_color)
        expect(verified_color).to eq('b')
      end
    end

    context 'when user input is invalid' do
      it 'returns nil' do
        invalid_input = 'pink'
        verified_color = game_verify_color.verify_player_color(invalid_input)
        expect(verified_color).to be_nil
      end

      it 'returns nil' do
        invalid_input = '&'
        verified_color = game_verify_color.verify_player_color(invalid_input)
        expect(verified_color).to be_nil
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
