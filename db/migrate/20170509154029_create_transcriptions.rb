class CreateTranscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :transcriptions do |t|
      t.belongs_to :project, null: false, foreign_key: true
      t.string :status, null: false, default: 'unreviewed'
      t.text :text

      t.timestamps
    end
  end
end
