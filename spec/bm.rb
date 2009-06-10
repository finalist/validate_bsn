require 'rubygems'
require 'lib/validate_bsn'
require 'benchmark'

n = 50_000

Benchmark.bm do |x|
  x.report { n.times { ValidateBSN.valid?(100_000_009) } }
end
