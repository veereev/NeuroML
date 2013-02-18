class CreateResultsPocs < ActiveRecord::Migration
  def change
    create_table :results_pocs do |t|
      t.integer :id
      t.string :type

      t.timestamps
    end
  end
end
