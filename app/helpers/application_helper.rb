module ApplicationHelper
  def markdown_format(text)
    if text.present?
      renderer = Redcarpet::Render::HTML.new(
        safe_links_only: true,
        no_styles: true,
        escape_html: true
      )
      markdown = Redcarpet::Markdown.new(
        renderer,
        autolink: true
      )
      %Q|<div class="contextual-message">#{markdown.render(text)}</div>|
    end
  end
end
