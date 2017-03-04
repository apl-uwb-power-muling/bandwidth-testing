#!//usr/bin/env ruby


infilename = ARGV.pop

abort "usage:   munge_mikrotik.rb <filename>" if !infilename

reset = true
s = nil
l = ""

out = []

File.open( infilename, 'r' ) { |f|

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
        str = "{ \"date\": \"#{stamp}\","

        bits = l.split(/\s{1}(?=[\w\-\.]*=)/)

        str += bits.select{ |b|
          b =~ /=/
        }.map { |b|
          key,val = b.split(/=/)


          val = "\"#{val}\"" unless val =~ /^\"/

          "    \"%s\" : %s" % [key, val]

        }.join(",\n")


        str += "}"
        end

        out << str
        reset = true
        s = nil
        l = ""
      end

    end
  rescue EOFError
  end

  puts "[#{out.join(',')}]"
}
