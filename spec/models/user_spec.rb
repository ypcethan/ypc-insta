require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }

  describe '#friends' do
    it 'returns list for friends' do
      user1.friendships.create(friend_id: user2.id, accepted_at: Time.now)
      user1.friendships.create(friend_id: user3.id)

      expect(user1.friends.map(&:id)).to include(user2.id)
      expect(user1.friends.map(&:id)).to_not include(user3.id)
    end
  end

  describe '#friend_requested?' do
    it do
      user1.friendships.create(friend_id: user2.id)
      expect(user1.friend_requested?(user2)).to be_truthy
    end
  end

  describe '#send_frend_request' do
    context 'when no friendship record exist' do
      it 'creates a new record' do
        user1.send_frend_request(user2)
        expect(user1.friend_requested?(user2)).to be_truthy
      end
    end

    context 'when the friendship record already exist' do
      it 'does not create a new one' do
        user1.send_frend_request(user2)
        expect {
          user1.send_frend_request(user2)
        }.to change{ user1.friendships.count }.by(0)
      end
    end
  end

  describe '#accept_request' do
    it 'creates mutual friendship' do
      user2.send_frend_request(user1)
      user1.accept_request(user2)

      expect(user1.friends.map(&:id)).to include(user2.id)
    end
  end

  describe '#friendship_requests' do

    it do
      user2.send_frend_request(user1)
      user3.send_frend_request(user1)
      expect(user1.friendship_requests.map(&:id)).to include(user2.id, user3.id)
    end

    it  do
      user2.send_frend_request(user1)
      user3.send_frend_request(user1)

      user1.accept_request(user2)

      ids = user1.friendship_requests.map(&:id)
      expect(ids).to include(user3.id)
      expect(ids).to_not include(user2.id)
    end
  end
end
