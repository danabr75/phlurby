class UsersAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments_users, :id => false do |t|
      t.integer :attachment_id
      t.integer :user_id
    end
  end
end
