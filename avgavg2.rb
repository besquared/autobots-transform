require 'rubygems'
require 'benchmark'
require 'lib/autobots_transform'

raw_largo = []
100000.times do
  raw_largo << [
    (rand * 100).round,
    (rand * 100).round,
    (rand * 1000).round,
    (rand * 1000).round
  ]
end

table = AutobotsTransform::Table.new(
  :data => raw_largo,
  :column_names => ['hour', 'agent', 'balance[coins]', 'occurred_at']
)

puts Benchmark.measure {
  table.pivot('hour', :group_by => 'agent') do |group|
    group.sum('balance[coins]')
  end
  
  # grouped = AutobotsTransform::Grouping.new(table, :by => ['hour', 'agent'])
  # puts grouped.to_s#groups(1).to_s
}