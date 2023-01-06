class Post < ApplicationRecord
  has_rich_text :content
  has_one_attached :photo
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  acts_as_taggable_on :categories

  def published_ago
    e = (Date.today - Date.parse(created_at.to_s)).to_i
    if e == 0
      "publié aujourd'hui"
    elsif e == 1
      "publié hier"
    elsif e > 1 && e < 7
      "il y a #{e} jours"
    elsif e >= 7 && e < 14
      "il y a #{e.fdiv(7).floor} semaine"
    elsif e >= 7 && e < 30
      "il y a #{e.fdiv(7).floor} semaines"
    elsif e >= 30 && e <= 365
      "il y a #{e.fdiv(30).floor} mois"
    else
      "il y a + d'1 an"
    end
  end

  def structured_data
    {
      '@context': "https://schema.org",
      '@type': "BlogPosting",
      headline: title,
      datePublished: created_at,
      dateModified: updated_at,
      author: [
        {
          '@type': "Organization",
          name: "Demain Works",
          url: "https://demain.works/"
        }
      ]
    }.to_json.html_safe
  end
end
