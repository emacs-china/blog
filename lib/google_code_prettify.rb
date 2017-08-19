# To fix kramdown code block output for Google Code Prettify
class FooFilter < Nanoc::Filter
  require 'nokogiri'
  identifier :google_code_prettify

  def run(content, _params)
    html_doc = Nokogiri::HTML(content)
    html_doc.css('pre').add_class('prettyprint')
    html_doc.to_html
  end
end
