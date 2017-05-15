class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :slug, null: :false
      t.index :slug, unique: true
    end
  end
end
