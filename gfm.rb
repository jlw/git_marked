#!/usr/bin/env ruby
#  Github-flavored markdown to HTML, in a command-line util.
#
#  $ cat README.md | ./gfm.rb
#
#  Notes:
#
#  You will need to install Pygments for syntax coloring
#
#    $ sudo easy_install pygments
#
#  Install the gems redcarpet, albino, and nokogiri
#
#

require 'rubygems'

gem 'redcarpet', '1.17.2'
require 'redcarpet'
require 'albino'
require 'nokogiri'

def markdown(text)
  options = [:fenced_code,:generate_toc,:hard_wrap,:no_intraemphasis,:strikethrough,:gh_blockcode,:autolink,:xhtml,:tables]
  html = Redcarpet.new(text, *options).to_html 
  syntax_highlighter(html)
end

def syntax_highlighter(html)
  doc = Nokogiri::HTML(html)
  doc.search("//pre[@lang]").each do |pre|
    pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
  end
  doc.at_css("body").inner_html.to_s
end

puts markdown(ARGF.read)
