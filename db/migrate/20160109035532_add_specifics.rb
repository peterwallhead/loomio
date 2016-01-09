class AddSpecifics < ActiveRecord::Migration
  def change
    create_table :specific do |t|
      t.belongs_to :specifiable, polymorphic: true
      t.string :key
      t.string :value
      t.timestamps
    end
  end
end
