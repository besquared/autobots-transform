require 'rubygems'
require 'benchmark'
require 'lib/autobots_transform'

raw_largo = []
10.times do
  raw_largo << [
    (rand * 2).round,
    (rand * 2).round,
    (rand * 1000).round,
    (rand * 1000).round
  ]
end

table = Measurely::Table.new(
  :data => raw_largo,
  :column_names => ['hour', 'agent', 'balance[coins]', 'occurred_at']
)

puts Benchmark.measure {
  grouped = Measurely::Grouping.new(table, :by => ['hour', 'agent'])
  puts grouped.to_s#groups(1).to_s
}