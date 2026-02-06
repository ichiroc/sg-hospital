class RemoveBirthDateFromAppointments < ActiveRecord::Migration[8.1]
  def change
    remove_column :appointments, :birth_date, :date
  end
end
