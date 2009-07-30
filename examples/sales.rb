require 'rubygems'
require 'benchmark'

require File.join(File.dirname(__FILE__), '..', 'lib', 'autobots_transform')

#
# Top selling store by region
#

raw = [
  ['1', '1', '100'],
  ['1', '2', '250'],
  ['2', '3', '50'],
  ['3', '4', '350'],
  ['3', '5', '200'],
  ['3', '6', '400']
]

table = AutobotsTransform::Table.new(
  :data => raw,
  :column_names => ['region', 'store', 'sales']
)

top_stores = table.group_by('region').collect do |region, stores|
  stores.top(1, 'sales', :order => :descending)
end

puts top_stores