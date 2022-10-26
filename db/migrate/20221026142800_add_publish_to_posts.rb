class AddPublishToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :publish, :boolean, default: false
  end
end
