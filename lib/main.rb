use_helper Nanoc::Helpers::Rendering # Partial layout
use_helper Nanoc::Helpers::Blogging  # Articles, RSS
use_helper Nanoc::Helpers::LinkTo    # link_to_post

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

#+TITLE: A very cool title
#+DATE: <2017-08-21 Mon>
#+AUTHOR: A very cool Dog
#
# (info "(org) In-buffer settings")
def parse_org_in_buffer_settings(file)
  title, author, created_at = nil, nil, nil
  File.open(file) do |f|
    f.each_line do |l|
      if l =~ /^#\+TITLE:(.*)$/i
        title = $1.strip
      elsif l =~ /^#\+AUTHOR:(.*)$/i
        author = $1.strip
      elsif l =~ /^#\+DATE:(.*)$/i
        created_at = $1.strip
      end
      if title && author && created_at
        break
      end
    end
  end
  [title, author, created_at]
end
