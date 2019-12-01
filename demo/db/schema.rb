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

  create_table :active_storage_blobs do |t|
    t.string   :key,        null: false
    t.string   :filename,   null: false
    t.string   :content_type
    t.text     :metadata
    t.bigint   :byte_size,  null: false
    t.string   :checksum,   null: false
    t.datetime :created_at, null: false

    t.index [ :key ], unique: true
  end

  create_table :active_storage_attachments do |t|
    t.string     :name,     null: false
    t.references :record,   null: false, polymorphic: true, index: false
    t.references :blob,     null: false

    t.datetime :created_at, null: false

    t.index [ :record_type, :record_id, :name, :blob_id ], name: "index_active_storage_attachments_uniqueness", unique: true
    t.foreign_key :active_storage_blobs, column: :blob_id
  end

  create_table :action_text_rich_texts do |t|
    t.string     :name, null: false
    t.text       :body, size: :long
    t.references :record, null: false, polymorphic: true, index: false

    t.timestamps

    t.index [ :record_type, :record_id, :name ], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

end
