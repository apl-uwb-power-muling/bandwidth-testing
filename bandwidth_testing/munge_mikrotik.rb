#!//usr/bin/env ruby


infilename = ARGV.pop

abort "usage:   munge_mikrotik.rb <filename>" if !infilename

reset = true
s = nil
l = ""

File.open( infilename, 'r' ) { |f|

  puts "["

  begin
    while line = f.readline do

      stamp,rest = line.split(/\s{2,}/)

      if rest
        if reset
          reset = false
        end

        s = stamp unless s

        l += rest + " "

      else
        unless reset
        ## Break out the keys in the Mikrotik format
        puts "{ \"time\": \"#{stamp}\","

        bits = l.split(/\s{1}(?=[\w\-]*=)/)

        puts bits.select{ |b|
          b =~ /=/
        }.map { |b|
          key,val = b.split(/=/)


          val = "\"#{val}\"" unless val =~ /^\"/

          "    \"%s\" : %s" % [key, val]

        }.join(",\n")


        puts "},"
        end
        reset = true
        s = nil
        l = ""
      end

    end
  rescue EOFError
  end

  puts "]"
}
