# frozen_string_literal: true

class CreateForceRates < ActiveRecord::Migration[5.2]
  def change
    create_table :force_rates do |t|
      t.string   :rate,       null: false
      t.integer  :valute,     default: 0
      t.datetime :expired_at, null: false

      t.timestamps
    end

    add_index :force_rates, :valute, unique: true
  end
end
