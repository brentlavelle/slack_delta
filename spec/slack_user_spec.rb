require 'rspec'
require 'json'
require_relative '../lib/slack_user'

# Just what is needed
minimal = JSON.parse('{"id":"U0000000A","deleted":false,"profile":{"email":"email@example.com","first_name":"firstname","last_name":"lastname"},"is_bot":false,"is_app_user":false,"updated":1504249016}')
minimal_delete = minimal.clone.merge({'deleted' => true})
new_name_hash = JSON.parse('{"id":"U0000000A","deleted":false,"profile":{"email":"email@example.com","first_name":"new_first","last_name":"lastname"},"is_bot":false,"is_app_user":false,"updated":1504249016}')


# A full message I pulled from slack
full = JSON.parse('{"id":"U0000000A","team_id":"T00000001","name":"first last","deleted":false,"profile":{"title":"title","phone":"2125551212","skype":"","real_name":"First LaSt","real_name_normalized":"First Last","display_name":"display","display_name_normalized":"display","fields":{"Xf11111111":{"value":"","alt":""}},"status_text":"","status_emoji":"","status_expiration":0,"avatar_hash":"OS1111111111","email":"email@example.com","first_name":"firstname","last_name":"lastname","image_48":"https://avatars.slack-edge.com/2015-01-01/1111111111_48.jpg","image_72":"https://avatars.slack-edge.com/2015-01-01/1111111111_72.jpg","image_192":"https://avatars.slack-edge.com/2015-01-01/11111111_192.jpg","image_512":"","status_text_canonical":"","team":"T01111111"},"is_bot":false,"is_app_user":false,"updated":1504249016,"presence":"away"}')

describe SlackUser.new(minimal) do
  it { is_expected.to be_a(SlackUser) }
  it { expect(subject.first_name).to be == minimal['profile']['first_name'] }
  it { expect(subject.last_name).to be == minimal['profile']['last_name'] }
  it { expect(subject.fl_name).to be == minimal['profile']['first_name']+' '+minimal['profile']['last_name'] }
  it { expect(subject.email).to be == minimal['profile']['email'] }
  it { expect(subject.deleted?).to be == minimal['deleted'] }
  it { expect(subject.updated).to be == minimal['updated'] }
  it { expect(subject.bot?).to be == minimal['bot'] }
end

describe SlackUser.new(full) do
  it { is_expected.to be_a(SlackUser) }
  it { expect(subject.first_name).to be == full['profile']['first_name'] }
  it { expect(subject.last_name).to be == full['profile']['last_name'] }
  it { expect(subject.fl_name).to be == full['profile']['first_name']+' '+full['profile']['last_name'] }
  it { expect(subject.email).to be == full['profile']['email'] }
  it { expect(subject.deleted?).to be == full['deleted'] }
  it { expect(subject.updated).to be == full['updated'] }
  it { expect(subject.bot?).to be == full['bot'] }
end

describe 'Deactivated' do
  let(:original) { SlackUser.new(minimal) }
  let(:deleted) { SlackUser.new(minimal_delete) }

  it { expect(original.deleted?).to be false}
  it { expect(deleted.deleted?).to be true}
  it { expect(original.compare(deleted)).to be == 'deactivated'}
  it { expect(original.same?(deleted)).to be false}
  it { expect(original.compare(original)).to be == 'no changes detected'}
  it { expect(deleted.compare(deleted)).to be == 'no changes detected'}
  it { expect(deleted.same?(deleted)).to be true}
  it { expect(deleted.compare(original)).to be == 'activated'}
end

describe 'Name change' do
  let(:original) { SlackUser.new(minimal) }
  let(:new_name) { SlackUser.new(new_name_hash) }

  it { expect(original.compare(new_name)).to be == 'first name changed from firstname to new_first'}
  it { expect(original.same?(new_name)).to be false}
end
