#!/usr/bin/ruby

def keyword
   i=0
   while i<=200
      puts "keyword at: #{Time.now}"
      sleep(0.1)
      i=i+1
   end
end

def ontology
   j=0
   while j<=200
      puts "ontology at: #{Time.now}"
      sleep(0.1)
      j=j+1
   end
end

puts "Started At #{Time.now}"
t1=Thread.new{keyword()}
t2=Thread.new{ontology()}
t1.join
t2.join
puts "End at #{Time.now}"
