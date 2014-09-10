require 'spec_helper'
require 'launchy'

feature 'Users can play Ten Thousand' do

  scenario 'Users play' do
    pending
    srand(1)
    create_user
    login_user
    visit '/'
    click_link 'New Game'
    fill_in 'Player 1', :with => 'Albert'
    fill_in 'Player 2', :with => 'Emily'
    click_on "Let's Play!"

    within('.total_scores') do
      expect(page).to have_content('Albert - 0')
      expect(page).to have_content('Emily - 0')
    end
    expect(page).to have_content('Albert, you are up!')

    within('.current_game') do
      expect(page).to have_content('Current Score: 0')
    end

    click_on "Roll"
    expect(page).to have_content('⚀ ⚁ ⚃ ⚃ ⚄ ⚅')
    check 'dice_0'
    check 'dice_4'
    click_on "Roll"
    expect(page).to have_content('⚀ ⚀ ⚁ ⚅')
    expect(page).to have_content('Current Score: 150')
    check 'dice_0'
    check 'dice_1'
    click_on 'Stay'
    expect(page).to have_content('Current Score: 0')
    expect(page).to have_content('Albert - 350')
    expect(page).to have_content('Emily, you are up!')
    expect(page).to_not have_content('You rolled:')
    click_on 'Roll'
    expect(page).to have_content('⚁ ⚂ ⚄ ⚄ ⚄ ⚅')
    check 'dice_2'
    check 'dice_3'
    check 'dice_4'
    click_on 'Roll'
    expect(page).to have_content('⚂ ⚄ ⚅')
    check 'dice_1'
    click_on 'Stay'
    expect(page).to have_content('Emily - 550')
    expect(page).to have_content('Albert, you are up!')
    click_on 'Roll'
    expect(page).to have_content('⚂ ⚂ ⚃ ⚄ ⚄ ⚅')
    check 'dice_3'
    check 'dice_4'
    click_on 'Roll'
    expect(page).to have_content('⚀ ⚁ ⚁ ⚄')
    check 'dice_0'
    check 'dice_3'
    click_on 'Roll'
    expect(page).to have_content('⚁ ⚅')
    expect(page).to have_content('Current Score: 0')
    click_on('Awww, man!')
    expect(page).to have_content('Albert - 350')
    expect(page).to have_content('Emily, you are up!')
    click_on 'Roll'
    expect(page).to have_content('⚀ ⚁ ⚁ ⚁ ⚄ ⚅')
    click_on 'Roll'
    expect(page).to have_content('⚀ ⚁ ⚁ ⚁ ⚄ ⚅')
    check 'dice_0'
    check 'dice_1'
    check 'dice_2'
    check 'dice_3'
    check 'dice_4'
    check 'dice_5'
    click_on 'Roll'
    expect(page).to have_content('⚁')
    expect(page).to_not have_unchecked_field('⚁')
    click_on 'Awww, man!'
    click_on 'Roll'
    expect(page).to have_content('⚀ ⚀ ⚁ ⚂ ⚃ ⚅')
    check 'dice_2'
    click_on 'Roll'
    expect(page).to have_content('⚀ ⚀ ⚁ ⚂ ⚃ ⚅')
    srand(Random.new_seed)
  end

end
