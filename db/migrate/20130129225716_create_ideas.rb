class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.text :body

      t.timestamps
    end
  end
end
