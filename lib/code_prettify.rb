module Nanoc
  module Filters
    module CodePrettify
      # To fix kramdown code block output for Code Prettify
      class Kramdown < Nanoc::Filter
        require 'nokogiri'
        identifier :google_code_prettify_kramdown

        def run(content, params={})
          doc = Nokogiri::HTML(content)
          doc.css('pre').add_class('prettyprint')
          doc.to_html
        end
      end

      # to fix pandoc's code block output for Code Prettify
      class Pandoc < Nanoc::Filter
        require 'nokogiri'
        identifier :google_code_prettify_pandoc

        def run(content, params={})
          doc = Nokogiri::HTML(content)
          doc.css('pre > code').each do |element|
            next unless element.parent['class']
            next if element.parent['class'] == 'example'

            element['class'] ||= ""
            element.parent['class'].split(/\s+/).each do |cl|
              cl = 'el' if cl == 'elisp'
              element['class'] <<= " language-#{cl}"
            end
            element.parent['class'] = 'prettyprint'
            element['class'] = element['class'].strip
          end
          doc.to_html
        end
      end
    end
  end
end
