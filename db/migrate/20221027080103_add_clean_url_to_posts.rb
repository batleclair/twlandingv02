class AddCleanUrlToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :clean_url, :string
  end
end
