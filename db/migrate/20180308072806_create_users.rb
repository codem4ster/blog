class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username, index: true
      t.string :password_digest
      t.string :activation_token, index: true
      t.string :reset_token, index: true
      t.timestamp :last_login, index: true
      t.string :name
      t.string :surname
      t.string :email, index: true
      t.string :roles, array: true, index: { using: :gin }

      t.timestamps
    end
  end
end
