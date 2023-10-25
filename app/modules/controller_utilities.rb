module ControllerUtilities
  def to_boolean(var)
    case var
      when true, 'true', 1, '1'
        return true
      when false, 'false', 0, '0'
        return false
    end
  end

  def legit?(path)
    [
      "company_user/selections/show_suggestion",
      "company_user/selections/show_selection",
      "company_user/selections/show_rejection",
      "company_user/offers/show",
      "company_user/candidacies/show_abandonned",
      "company_user/candidacies/show_assessing",
      "company_user/candidacies/show_validating"
    ].include?(path)
  end
end
