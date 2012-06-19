class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username # TODO: change to 'name'
      t.string :email
      t.string :password_digest
      t.string :uid
      t.string :token
      t.string :secret

      t.timestamps
    end
  end
end
