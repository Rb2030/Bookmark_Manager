require_relative '../spec_helper'

feature 'Creating links' do
  scenario 'I can create a new link' do
    visit '/links/new'
    fill_in 'url', with: 'http://www.zombo.com/'
    fill_in 'title', with: 'This is Zombocom'
    click_button :submit
    expect(current_path).to eq '/links'

    within 'ul#links' do
      expect(page).to have_content('This is Zombocom')
    end
  end
end

feature 'Tags' do
  scenario 'I can add a single tag to a new link' do
    visit '/links/new'
    fill_in 'url', with: 'http://www.zombo.com/'
    fill_in 'title' , with: 'This is Zombocom'
    fill_in 'tag', with: 'Seahorse'
    click_button :submit
    link = Link.first
    expect(link.tags.map(&:name)).to include('Seahorse')
  end
  scenario 'When you visit bubbles, only links tagged with bubbles show' do
    visit '/links/new'
    fill_in 'url', with: 'http://www.zombo.com/'
    fill_in 'title' , with: 'This is Zombocom'
    fill_in 'tag', with: 'Seahorse'
    click_button :submit
    visit '/links/new'
    fill_in 'url', with: 'http://www.reddit.com'
    fill_in 'title' , with: 'This is Reddit'
    fill_in 'tag', with: 'bubbles'
    click_button :submit
    visit '/tags/bubbles'
    expect(page).to have_content('This is Reddit')
    expect(page).not_to have_content('This is Zombocom')
  end
end
