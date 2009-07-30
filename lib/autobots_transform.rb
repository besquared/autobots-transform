require File.join(File.dirname(__FILE__), 'autobots_transform', 'table')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'grouping')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'group')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'formatter')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'text_formatter')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'csv_formatter')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'xml_formatter')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'json_formatter')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'yaml_formatter')

require 'yaml' unless defined?(YAML)
if RUBY_VERSION.include?('1.9')
  # In 1.9, the native CSV implementation is "FasterCSV plus support for Ruby 1.9's m17n encoding engine"
  require 'csv'
  require 'stringio' unless defined?(StringIO)
else
  require 'fastercsv' unless defined?(FasterCSV)
end
I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2 = "for nokogiri on Leopard"
require 'nokogiri' unless defined?(Nokogiri)
require 'yajl' unless defined?(Yajl)