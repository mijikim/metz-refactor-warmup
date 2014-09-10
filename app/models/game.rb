class Game < ActiveRecord::Base
  serialize :last_roll, Array
  has_many :players

  def initialize(params)
    player_1_name = params.delete("player_1")
    player_2_name = params.delete("player_2")

    super(params)
    self.players.new(player_name: player_1_name, total_score: 0, current_score: 0)
    self.players.new(player_name: player_2_name, total_score: 0, current_score: 0)
    self.available_dice = 6
    self.player_iterator = 0
    # do our logic here?
  end

  def current_player
    if new_record?
      self.players.first
    else
      self.players.order(:id)[self.player_iterator]
    end
  end

  def roll_again(scoring_dice)
    player = current_player
    self.available_dice -= scoring_dice.length
    self.save
    score = score(scoring_dice)
    player.current_score += score
    self.available_dice = 6 if self.available_dice == 0
    self.last_roll = roll_dice if scoring_dice == [] || score > 0
    self.save
    player.save
  end

  def bust
    player = current_player
    player.current_score = 0
    player.save
  end

  def stay(scoring_dice)
    player = current_player
    self.player_iterator += 1
    self.player_iterator = 0 if self.player_iterator >= self.players.length
    self.last_roll = []
    self.available_dice = 0
    self.save
    player.total_score ||= 0
    player.current_score ||=0
    player.current_score += score(scoring_dice)
    player.total_score += player.current_score
    player.current_score = 0
    player.save
  end

  def roll_dice
    dice = {1 => '⚀',
            2 => '⚁',
            3 => '⚂',
            4 => '⚃',
            5 => '⚄',
            6 => '⚅',
    }
    (1..self.available_dice).map { rand(1..6) }.sort.map { |face| [face, dice[face]] }
  end

  def score(scoring_dice)

    @tally_score = 0

    if straight_method(scoring_dice)
    elsif three_pairs_method(scoring_dice)
    elsif two_three_of_a_kind_method(scoring_dice)
    elsif kind_method(scoring_dice)
    end

    one_and_five_method(scoring_dice)

    rejected_dice = scoring_dice

    self.available_dice += rejected_dice.length

    @tally_score
  end

  def one_and_five_method(scoring_dice)
    @tally_score += scoring_dice.count('1') * 100 if scoring_dice.count('1') > 0 && scoring_dice.count('1') < 3
    scoring_dice.delete('1')
    @tally_score += scoring_dice.count('5') * 50 if scoring_dice.count('5') > 0 && scoring_dice.count('5') < 3
    scoring_dice.delete('5')
  end

  def two_three_of_a_kind_method(scoring_dice)
    if scoring_dice.length == 6 && scoring_dice.uniq.length != 1
      if (scoring_dice[0..2] && scoring_dice[0..2].length == 3 && scoring_dice[1..2].all? { |scoring_die| scoring_die == scoring_dice[0] }) &&
        (scoring_dice[3..5] && scoring_dice[3..5].length == 3 && scoring_dice[4..5].all? { |scoring_die| scoring_die == scoring_dice[3] })
        kind_0 = scoring_dice[0]
        kind_1 = scoring_dice[3]
        if kind_0 == '1'
          @tally_score = 1000 + kind_1.to_i * 100
        else
          @tally_score = kind_0.to_i * 100 + kind_1.to_i * 100
        end
        scoring_dice.clear
      end
    end
  end

  def three_pairs_method(scoring_dice)
    if scoring_dice[0] == scoring_dice[1] && scoring_dice[2] == scoring_dice[3] && scoring_dice[4] == scoring_dice[5] && scoring_dice.length == 6 &&
      !scoring_dice.all? { |scoring_die| scoring_dice[0] == scoring_die }
      @tally_score = 750
      scoring_dice.clear
    end
  end

  def straight_method(scoring_dice)
    if scoring_dice == ['1', '2', '3', '4', '5', '6']
      @tally_score = 1500
      scoring_dice.clear
    end
  end

  def kind_method(scoring_dice)
    if scoring_dice.length >= 3 && scoring_dice.uniq.length == 1
      number_of_kind = scoring_dice.length
      kind = scoring_dice[0]
      if kind == '1'
        @tally_score = 1000 * (number_of_kind - 2)
      else
        @tally_score = kind.to_i * 100 * (2**(number_of_kind - 3))
      end
      scoring_dice.delete(kind)
    end
  end

end
