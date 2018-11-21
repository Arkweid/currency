class CreateForceRates < ActiveRecord::Migration[5.2]
  def change
    create_table :force_rates do |t|
      t.string :rate
      t.datetime :expired_at

      t.timestamps
    end
  end
end
