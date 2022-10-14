json.valid @experience.valid?
json.id @experience.id
json.errors @experience.errors
json.content render partial: "xp_list", formats: :html, locals: { experiences: @experiences }
