class ProjectsTasks < ActiveRecord::Migration[5.2]
  def change
      create_table :projects do |t|
        t.string :name
        t.date :due_date
        t.timestamps
      end

      create_table :tasks do |t|
        t.references :project, foreign_key: true
        t.string :title
        t.integer :size
        t.datetime :completed_at
        t.integer :project_order
        t.timestamps
      end
  end
end
