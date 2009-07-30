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

#
# Output 
#
# +------------------------+
# | region | store | sales |
# +------------------------+
# | 1      | 2     | 250   |
# | 2      | 3     | 50    |
# | 3      | 6     | 400   |
# +------------------------+


#
# Nested top selling stores by region and state combination
#

raw = [
  ['1', 'CA', '1', '100'],
  ['1', 'CA', '2', '250'],
  ['2', 'GA', '3', '50'],
  ['3', 'WA', '4', '350'],
  ['3', 'WA', '5', '200'],
  ['3', 'OR', '6', '400']
]

table = AutobotsTransform::Table.new(
  :data => raw,
  :column_names => ['region', 'state', 'store', 'sales']
)

by_region_state = table.group_by(['region', 'state'])

top_stores = by_region_state.collect do |region, regioned|
  regioned.collect do |state, stated|
    stated.top(1, 'sales', :order => :descending)
  end
end

puts top_stores

#
# Output
#
# +--------------------------------+
# | region | state | store | sales |
# +--------------------------------+
# | 1      | CA    | 2     | 250   |
# | 2      | GA    | 3     | 50    |
# | 3      | OR    | 6     | 400   |
# | 3      | WA    | 4     | 350   |
# +--------------------------------+

