require File.join(File.dirname(__FILE__), 'autobots_transform', 'table')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'grouping')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'group')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'text_formatter')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'csv_formatter')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'xml_formatter')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'json_formatter')

require 'fastercsv' unless defined?(FasterCSV)
I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2 = "for nokogiri on Leopard"
require 'nokogiri' unless defined?(Nokogiri)
require 'yajl' unless defined?(Yajl)