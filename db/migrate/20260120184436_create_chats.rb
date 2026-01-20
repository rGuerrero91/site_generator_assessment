class CreateChats < ActiveRecord::Migration[8.0]
  def change
    create_table :chats do |t|
      t.text :message
      t.text :html_response
      t.text :follow_up_messages

      t.timestamps
    end
  end
end
