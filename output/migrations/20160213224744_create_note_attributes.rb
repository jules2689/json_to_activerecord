class CreateNoteAttributes < ActiveRecord::Migration
  create_table :note_attributes do |t|
    t.string :name
    t.string :value
    t.references :orders, index: true
    t.timestamps  null: false
  end
end