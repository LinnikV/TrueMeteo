module ApplicationHelper
  def full_title(page_title = "")
    base = "TrueMeteo"
    if page_title.present?
      "#{page_title} | #{base}"
    else
      base
    end
  end
end
