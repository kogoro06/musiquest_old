class AddDeviseToUsers < ActiveRecord::Migration[6.0]
  def up
    change_table :users do |t|
      # t.string :encrypted_password, null: false, default: ""  # 既存のためコメントアウト
      # 他のDeviseカラムを追加
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
