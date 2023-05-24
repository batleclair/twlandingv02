module ControllerUtilities
  def to_boolean(var)
    case var
      when true, 'true', 1, '1'
        return true
      when false, 'false', 0, '0'
        return false
    end
  end
end
