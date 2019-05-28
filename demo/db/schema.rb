ActiveRecord::Schema.define(version: 1) do

  create_table :users, force: :cascade do |t|
    t.integer :account_id
    t.string  :email
    t.string  :username
    t.string  :password
    t.boolean :terms, default: false
    t.string  :test
    t.string  :bio
    t.string  :color
    t.string  :locale
    t.datetime :datetime
    t.timestamps
  end

end
