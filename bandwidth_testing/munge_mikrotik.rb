#!//usr/bin/env ruby


infilename = ARGV.pop

abort "usage:   munge_mikrotik.rb <filename>" if !infilename

p infilename

last_stamp = ""
File.open( infilename, 'r' ) { |f|

  begin
  while line = f.readline do

    stamp,rest = line.chomp.split(/\s{2,}/)

    if stamp != last_stamp
      last_stamp = stamp

      if rest
        puts
        print stamp, "  "
      end
    end
    print rest if rest and rest.length() > 0

  end
rescue EOFError
  puts
  break
end

}
