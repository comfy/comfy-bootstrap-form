ActiveRecord::Schema.define(version: 1) do

  create_table :users, force: :cascade do |t|
    t.string  :email
    t.string  :password
    t.boolean :terms, default: false
    t.string  :test
    t.timestamps
  end

end
