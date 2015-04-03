class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.integer :user_id
      t.string :todo_content
      t.boolean :completed, default: false
      t.integer :category

      t.timestamps
    end
  end
end