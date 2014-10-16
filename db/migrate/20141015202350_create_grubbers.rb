class CreateGrubbers < ActiveRecord::Migration
  def change
    create_table :grubbers do |t|
      t.string :mobile
      t.string :email
      t.boolean :subscribed
      t.boolean :text_ok
      t.boolean :email_ok
      t.string :password

      t.timestamps
    end
  end
end
