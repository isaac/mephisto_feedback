class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.integer  :site_id
      t.string   :name
      t.string   :email
      t.string   :key
      t.text     :body
      t.datetime :created_at
    end
  end
  
  def self.down
    drop_table :feedbacks
  end
end