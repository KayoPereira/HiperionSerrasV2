module ServicesHelper
  def render_service_details(details)
    allowed_tags = (Rails::HTML5::SafeListSanitizer.allowed_tags.to_a + [
      "action-text-attachment",
      "figure",
      "figcaption",
      "span"
    ]).uniq

    allowed_attributes = (Rails::HTML5::SafeListSanitizer.allowed_attributes.to_a + [
      "style",
      "sgid",
      "content-type",
      "url",
      "href",
      "filename",
      "filesize",
      "width",
      "height",
      "previewable",
      "presentation",
      "caption"
    ]).uniq

    sanitize(details.body.to_html, tags: allowed_tags, attributes: allowed_attributes)
  end
end
