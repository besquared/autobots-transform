require File.join(File.dirname(__FILE__), 'autobots_transform', 'table')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'grouping')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'group')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'text_formatter')
require File.join(File.dirname(__FILE__), 'autobots_transform', 'csv_formatter')

require 'fastercsv' unless defined?(FasterCSV)