require 'rspec'
require 'json'
require_relative '../lib/slack_user_collection'

one = "
---
U2U66J511: !ruby/object:SlackUser
  user_id: U2U66J511
  deleted: false
  first_name: First
  last_name: Last
  email: first_last@example.com
"
two = "
---
U2U66J511: !ruby/object:SlackUser
  user_id: U2U66J511
  deleted: false
  first_name: First
  last_name: Last
  email: first_last@example.com
U2U66J512: !ruby/object:SlackUser
  user_id: U2U66J512
  deleted: false
  first_name: Second
  last_name: User
  email: second_user@example.com
"
three = "
---
U2U66J511: !ruby/object:SlackUser
  user_id: U2U66J511
  deleted: false
  first_name: First
  last_name: Last
  email: first_last@example.com
U2U66J512: !ruby/object:SlackUser
  user_id: U2U66J512
  deleted: true
  first_name: Second
  last_name: User
  email: second_user@example.com
"



describe SlackUserCollection.new('') do
  it { is_expected.to be_a(SlackUserCollection) }
  it { expect(subject.size).to be == 0 }
end

describe SlackUserCollection.new(one) do
  it { is_expected.to be_a(SlackUserCollection) }
  it { expect(subject.size).to be == 1 }
end

describe SlackUserCollection.new(two) do
  it { is_expected.to be_a(SlackUserCollection) }
  it { expect(subject.size).to be == 2 }
end

describe 'diff' do
    let(:no_users) { SlackUserCollection.new('') }
    let(:one_user) { SlackUserCollection.new(one) }
    let(:two_users) { SlackUserCollection.new(two) }
    let(:third_state) { SlackUserCollection.new(three) }

    it { expect(no_users.diff(no_users)).to eq []}
    it { expect(one_user.diff(one_user)).to eq []}
    it { expect(two_users.diff(two_users)).to eq []}
    it 'add to nothing' do
      expect(no_users.diff(one_user)).to eq ["First Last: added"]
    end
    it 'remove to nothing' do
      expect(one_user.diff(no_users)).to eq ["First Last: removed"]
    end
    it 'remove one from two' do
      expect(two_users.diff(one_user)).to eq ["Second User: removed"]
    end
    it 'someone leaves the firm' do
      expect(two_users.diff(third_state)).to eq ["Second User: deactivated"]
    end
end
