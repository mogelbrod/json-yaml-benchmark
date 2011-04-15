require 'rubygems'
require 'benchmark'
require 'yaml'
#require 'json/pure'
require 'json/ext'

# Source data generator
require File.dirname(__FILE__) + '/data_generator'

# Flag to include all implementations
$all = ARGV.include?('all')
if $all
  require 'yajl'
  require 'zaml'
end

$save = ARGV.include?('save')
$output_dir = 'output'

puts "Saving serialized output in #{$output_dir}" if $save

# Benchmark method
def bench(name)
  puts
  print name.to_s.ljust(24)

  GC.start # start garbage collection
  printf('%.4fs', Benchmark.realtime { yield })
end

# Benchmark method which also dumps output
def bench_dump(test, name)
  string = nil
  bench(name) { string = yield }

  size = string.length
  if $save
    Dir.mkdir($output_dir) unless File.directory?($output_dir)
    path = "#{$output_dir}/#{test}.#{name.gsub(' ', '_')}.txt"
    File.open(path, 'w') { |f| f.write(string) }
    size = File.size(path)
  end
  printf('   %.4fkB', (size.to_f / 1024))
end

gen = DataGenerator.new
# Define and run tests
[
  [:simple,  lambda { gen.array(10_000) }],
  [:complex, lambda { gen.array_nested(1_000) }]
].each do |test|
  source = test[1].call
  test = test[0].to_s

  print (test.capitalize + ' ').ljust(50, '=')

  # Result variable
  out = nil

  # JSON
  bench_dump(test, 'JSON.generate') { out = JSON.generate(source) }
  bench_dump(test, 'JSON.pretty_generate') { out = JSON.pretty_generate(source) }
  bench('JSON.parse') { out = JSON.parse(out) }
  out = nil

  # YAML 
  bench_dump(test, 'YAML.dump') { out = YAML.dump(source) }
  bench('YAML.load') { out = YAML.load(out) }
  out = nil

  if $all # include other implementations?
    print "\n" + ('-' * 50)

    # YAJL
    bench_dump(test, 'yajl') { out = Yajl::Encoder.encode(source) }
    bench_dump(test, 'yajl pretty') { out = Yajl::Encoder.encode(source, :pretty => true) }
    bench('yajl load') { out = Yajl::Parser.parse(out) }
    out = nil

    # ZAML 
    bench_dump(test, 'zaml') { out = ZAML.dump(source) }
    out = nil
  end

  puts "\n\n"
end
