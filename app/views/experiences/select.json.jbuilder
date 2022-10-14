if @experience.id.nil?
  json.content render partial: "new_xp", formats: :html, locals: { experience: @experience, candidate: current_user.candidate }
else
  json.content render partial: "edit_xp", formats: :html, locals: { experience: @experience, candidate: @experience.candidate }
end
