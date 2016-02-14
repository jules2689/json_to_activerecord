class CreateNoteAttributes < ActiveRecord::Migration[5.0]
  create_table :note_attributes do |t|
    t.string :name
    t.string :value
    t.references :orders, index: true
    t.timestamps  null: false
  end
end