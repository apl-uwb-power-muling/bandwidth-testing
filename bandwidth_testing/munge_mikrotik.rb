#!//usr/bin/env ruby


infilename = ARGV.pop

abort "usage:   munge_mikrotik.rb <filename>" if !infilename

reset = true
File.open( infilename, 'r' ) { |f|

  begin
    while line = f.readline do

      stamp,rest = line.strip.split(/\s{2,}/)

      if rest
        if reset
          reset = false
          print stamp, " "
        end
        print rest
      else
        print "\n" unless reset
        reset = true
      end

    end
  rescue EOFError
    puts
    break
  end

}
