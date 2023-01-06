module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def to_json_ld(breadcrumbs)
    array = []
    output = {
      '@context': "https://schema.org",
      '@type': "BreadcrumbList",
      itemListElement: array
    }
    breadcrumbs.each_with_index do |crumb, index|
      array << {
        '@type': "ListItem",
        position: index + 1,
        name: crumb.name,
        item: crumb.path
      }
    end

    return output.to_json.html_safe
  end
end
