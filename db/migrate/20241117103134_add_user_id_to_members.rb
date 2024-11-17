class AddUserIdToMembers < ActiveRecord::Migration[6.1]
  def change
    
    add_reference :members, :user, foreign_key: true, null: true
  end
end
