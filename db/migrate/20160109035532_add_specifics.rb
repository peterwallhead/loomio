class AddSpecifics < ActiveRecord::Migration
  def change
    create_table :specifics do |t|
      t.belongs_to :specifiable, polymorphic: true
      t.string :key
      t.column :value, :hstore, default: {}
      t.timestamps
    end
  end
end
