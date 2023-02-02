json.valid @offer_bookmark.valid?
json.errors @offer_bookmark.errors
if @offer_bookmark.valid?
  json.content render partial: "offer_list", formats: :html, locals: { offers: @offers, bookmark: @offer_bookmark }
end
