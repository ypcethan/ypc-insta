class CreateFriendships < ActiveRecord::Migration[6.1]
  def change
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friend_id
      t.datetime :accepted_at

      t.timestamps
    end

    add_index :friendships, :user_id
    add_index :friendships, :friend_id
  end
end
