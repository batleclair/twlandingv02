class RenameCleanUrlToSlugInPosts < ActiveRecord::Migration[7.0]
  def change
    rename_column :posts, :clean_url, :slug
  end
end
