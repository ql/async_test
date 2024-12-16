class CreateSavedPages < ActiveRecord::Migration[7.1]
  def change
    create_table :saved_pages do |t|
      t.string :saved_pages
      t.string :url
      t.text :saved_body
      t.float :elapsed_time

      t.timestamps
    end
  end
end
