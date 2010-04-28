#!/usr/bin/env ruby
require 'rubygems'
require 'open-uri'
require 'kconv'
require 'hpricot'
require 'pp'

if ARGV.size < 1
  puts 'download pdf files'
  puts 'ruby acmportal.rb "http://portal.acm.org/toc.cfm?id=1517664&coll=ACM&dl=ACM&type=proceeding&idx=SERIES11433&part=series&WantType=Proceedings&title=TEI&CFID=86099218&CFTOKEN=41539595"'
  exit 1
end
uri = ARGV.shift

doc = Hpricot(open(uri).read.toutf8)

links = doc/:a
pdfs = Array.new
for i in 0...links.length
  pdfs << "http://portal.acm.org/"+links[i][:href].to_s
end

pdfs = pdfs.uniq.delete_if{|url|
  !(url =~ /pdf/)
}

pdfs.each{|url|
  puts url
  puts `wget "#{url}"`
  Dir.glob("*\?*").each{|name|
    `mv "#{name}" #{name.split(/\?/).first}`
  }
 }

