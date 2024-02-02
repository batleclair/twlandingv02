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
        item: "https://demain.works#{crumb.path}"
      }
    end
    return output.to_json.html_safe
  end

  def canonical(url)
    content_for(:canonical, tag(:link, rel: :canonical, href: url)) if url
  end

  def logo_for(beneficiary)
    beneficiary.logo.attached? ? cl_image_tag(beneficiary.logo.key) : cl_image_tag('../default_logo.png')
  end

  def hq_address
    "27 rue du Chemin Vert, 75011 PARIS"
  end

  Object.prepend(Module.new do
    def if_not(alt)
      self ? self : alt
    end
  end)
  String.prepend(Module.new do
    def to_domain
      self.slice(/@.+/)&.delete("@")
    end
  end)
end
