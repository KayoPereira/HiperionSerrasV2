module ProductsHelper
  def youtube_embed_url(video_url)
    return nil unless video_url.blank? == false

    video_id = extract_youtube_video_id(video_url)
    return nil unless video_id

    "https://www.youtube.com/embed/#{video_id}?rel=0&modestbranding=1"
  end

  def render_product_description(description)
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

    sanitize(description.body.to_html, tags: allowed_tags, attributes: allowed_attributes)
  end

  private

  def extract_youtube_video_id(url)
    # Match various YouTube URL formats
    if url.match?(/youtu\.be/)
      url.match(/youtu\.be\/([a-zA-Z0-9_-]+)/)[1] rescue nil
    elsif url.match?(/youtube\.com/)
      url.match(/v=([a-zA-Z0-9_-]+)/)[1] rescue nil
    elsif url.match?(/^[a-zA-Z0-9_-]+$/)
      # If it's just a video ID
      url
    else
      nil
    end
  end
end
