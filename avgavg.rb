# what's the total money supply in this scenario?
# hour 1 : 1 => 50, 2 => 250, 3 => 350 : 650
# hour 2 : 2 => 200, 3 => 400 : 600
# total money supply is the amount of money in all accounts at the end of the period
#
# average money supply is something different, it is the *average* balance of 
#  all accounts through a period.
#
# What is the average money supply in this scenario?
# hour 1 : 1 => 75, 2 => 250, 3 => 350 : 675
# hour 2 : 2 => 200, 3 => 400 => : 600
#
# So we see two problems, one is that money supply needs to be expressed in as
# a delta to the previous money supply number, it also needs to be expressed in
# terms of totals at the end of the period. This will make sure that we don't
# double count or overcount certain people. Really though is this money supply?
# What is the proper name for this? The real difference here is that it only
# involved *active* players in the economy, basically on an hourly basis large
# swaths of the virtual economy are likely to be inactive. We should just call
# this "Active Money Supply" which is the amount of money held by players that
# were active in a certain period of time, it should still be a sum at the end
# of the period of the balance for each user that was active

#
# we could put this in raw, group by users, sort by occurred_at, take the last
# row and create a new table and then group by hour with a sum
#

require 'rubygems'
require 'ruport'
require 'ruby-debug'
require 'benchmark'
require 'lib/autobots_transform'

raw = [
  ['1', '1', '100', '1'],
  ['1', '2', '250', '1'],
  ['1', '1', '50', '2'],
  ['1', '3', '350', '2'],
  ['2', '2', '200', '3'],
  ['2', '3', '400', '3']
]

table = Ruport::Data::Table.new(
  :data => raw,
  :column_names => ['hour', 'agent', 'balance[coins]', 'occurred_at']
)

raw_largo = []
100.times do
  raw_largo << [
    (rand * 100).round,
    (rand * 10).round,
    (rand * 1000).round,
    (rand * 1000).round
  ]
end


GC.disable

table = Ruport::Data::Table.new(
  :data => raw_largo,
  :column_names => ['hour', 'agent', 'balance[coins]', 'occurred_at']
)

puts Benchmark.measure {  
  table.sort_rows_by!(['agent', 'occurred_at'])

  final = Ruport::Data::Table.new(
    :column_names => ['hour', 'agent', 'balance[coins]']
  )

  by_hour = Ruport::Data::Grouping.new(table, :by => ['hour', 'agent'])

  by_hour.each do |hour, hourly|
    by_hour.subgrouping(hour).each do |agent, agently|
      record = agently.data.last
    
      final << {
        'hour' => hour,
        'agent' => agent,
        'balance[coins]' => record.get('balance[coins]')
      }
    end
  end
}

table = AutobotsTransform::Table.new(
  :data => raw_largo,
  :column_names => ['hour', 'agent', 'balance[coins]', 'occurred_at']
)

puts Benchmark.measure {  
  table.sort_rows_by!(['agent', 'occurred_at'])

  final = Ruport::Data::Table.new(
    :column_names => ['hour', 'agent', 'balance[coins]']
  )

  by_hour = Ruport::Data::Grouping.new(table, :by => ['hour', 'agent'])

  by_hour.each do |hour, hourly|
    by_hour.subgrouping(hour).each do |agent, agently|
      record = agently.data.last
    
      final << {
        'hour' => hour,
        'agent' => agent,
        'balance[coins]' => record.get('balance[coins]')
      }
    end
  end
}



GC.enable
GC.start

# grouping = Ruport::Data::Grouping.new(table, :by => ['hour'])      
# grouping.summary(
#   'hour', 'revenue' => lambda{|g| g.sigma('revenue')},
#   :order => ['hour', 'revenue']
# )
