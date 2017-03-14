#!//usr/bin/env ruby

require 'time'

infilename = ARGV.pop

abort "usage:   munge_mikrotik.rb <filename>" if !infilename


last_stamp = ""

class Entry
  attr_reader :start, :stop, :rate, :retries

  def initialize( start, stop, rate, retries )
    @start = start
    @stop = stop
    @rate = rate
    @retries = retries
  end
end

entries = []
max_stop = 0

File.open( infilename, 'r' ) { |f|

  begin
  while line = f.readline do

    stamp,rest = line.strip.split(/\[[\s\w]{3}\]/)
    next unless rest

    last_stamp = stamp

  if rest =~ /(\d+)-(\d+)/
    vals = rest.strip.split(/[\s\-]+/)

    start = vals[0].to_f
    stop = vals[1].to_f
    max_stop = stop if stop > max_stop

    rate = vals[5].to_f
    retries = vals[7].to_f

    entries <<  Entry.new( start, stop, rate, retries )
  end

  end
rescue EOFError
  break
end

}


end_time = Time::parse( last_stamp )
start_time = end_time - max_stop

entries.select { |entry|
  entry.stop - entry.start < 1.1
}.each { |entry|
  puts "%s,%f,%d" % [ (start_time + entry.start).strftime("%F %T"), entry.rate, entry.retries ]
}
