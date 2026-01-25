class CreateAppointments < ActiveRecord::Migration[8.1]
  def change
    create_table :appointments do |t|
      t.date :appointed_on, null: false
      t.string :appointed_slot, null: false
      t.string :name, null: false
      t.string :name_kana, null: false
      t.string :patient_number
      t.date :birth_date, null: false
      t.string :phone_number, null: false
      t.string :consultation_purpose, null: false
      t.string :status, default: "pending", null: false

      t.timestamps
    end

    add_index :appointments, [:appointed_on, :appointed_slot], unique: true
  end
end
