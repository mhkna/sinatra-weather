class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.integer :time
      t.integer :temperatrue_high
      t.string :summary
      t.string :icon

      t.timestamps
    end
  end
end
