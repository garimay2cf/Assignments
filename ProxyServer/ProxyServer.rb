
#exec('wget www.google.com --output-document=file1.txt')
#exec('more file1.txt')
require 'stringio'
#require 'pry'
#This is the class for the cache
class Cache
  attr_accessor :cache_hits, :cache_miss, :cache_entries, :cache_size
  @cache_table=Hash.new #It uses a hash webaddress=>[page_string,timestamp]
  def initialize(hits,miss,entries,size)
    @cache_hits=hits
    @cache_miss=miss
    @cache_entries=entries
    @cache_size=size
  end
  
  def self.get_cache()
    return @cache_table
  end
  
  def self.put_cache(cache)
    #binding.pry
    @cache_table=cache
  end
  
  def search(address)
    #binding.pry
    cache=Cache.get_cache
    if(!(cache.has_key?(address.to_sym))) #Cache Miss
      puts "It's a Cache Miss"
      #filename=address.split('.')
      command="wget #{address} --output-document=-"
      #exec(command)
      #exec('more proxyfile.txt')
      #aFile=File.open("proxyfile.txt", "r") do |aFile|
       # line=STDOUT.gets
       # puts(line)
      #end
      #aFile.close

      output = StringIO.new

      IO.popen(command) do |pipe| #to display the output and also to get it in a string
        pipe.each do |line|
         output.puts line
        puts line
          end
        end
        if($a_cache.cache_entries>=$a_cache.cache_size) 
          puts "Total number of enteries exceeded the maximum cache size"
          delete_page()
        end
      cache[address.to_sym]=[output.string,Time.now.to_i]
      #binding.pry
      Cache.put_cache(cache)
      $a_cache.cache_miss=$a_cache.cache_miss+1 #counter for cache miss
      $a_cache.cache_entries=$a_cache.cache_entries+1 #counter for total entries in the cache
      LogEntry.new.make_miss_entry(Time.now.strftime("%a %b %d %Y %H:%M:%S %z %Y"),address)
      
    else
      puts "It's a Cache Hit"
      cache=Cache.get_cache()
      puts "This is the cached entry #{cache[address.to_sym][0]}"
      cache[address.to_sym][1]=Time.now.to_i
      Cache.put_cache(cache)
      $a_cache.cache_hits=$a_cache.cache_hits+1 #counter for cache hits
      LogEntry.new.make_hit_entry(Time.now.strftime("%a %b %d %Y %H:%M:%S %z %Y"),address)
    end
      
  end
  
  
  def delete_page()
    cache=Cache.get_cache()
    min_key=cache.keys[0]
    min_time=cache[min_key][1]  
    
    cache.each do |k,v| #loop to find the minimum timestamp
      if v[1]!=min_time
        if v[1]<min_time
          min_time=v[1]
          min_key=k
        end
      end
      end
    puts "#{cache.delete(min_key).to_s} Deleted from cache"
    LogEntry.new.make_delete_entry(Time.now.strftime("%a %b %d %Y %H:%M:%S %z %Y"),min_key.to_s)
    Cache.put_cache(cache)
    $a_cache.cache_entries=$a_cache.cache_entries-1 #decrement the total number of entries in cache
  end
end


class ProxyServer
  $a_cache=Cache.new(0,0,0,0)
  def start()
    puts "Proxy Server Started"
    puts "Enter the cache size"
    size=gets
    $a_cache.cache_size=size.to_i
    puts "Cache of size:#{$a_cache.cache_size} with hits:#{$a_cache.cache_hits}, misses:#{$a_cache.cache_miss}, entries:#{$a_cache.cache_entries} initialized"
    LogEntry.new.make_start_entry(Time.now.strftime("%a %b %d %Y %H:%M:%S %z %Y"),$a_cache.cache_size)
  end
  
  def stop()
    puts "Proxy Server Exited"
    LogEntry.new.make_exit_entry(Time.now.strftime("%a %b %d %Y %H:%M:%S %z %Y"),$a_cache.cache_hits,$a_cache.cache_miss)
  end
  
  def request(url)
    puts "You requested url: #{url}"
    #binding.pry
    filename=$a_cache.search(url)
  end
end

class LogEntry

  def make_start_entry(timestamp,cache_size)
    @entry="#{timestamp.to_s} cache size #{cache_size.to_s}"
    aFile=File.new("log.txt","a+")
    aFile.puts(@entry)
    aFile.close
  end
  
  def make_hit_entry(timestamp,address)
    @entry= "#{timestamp.to_s} #{address} cache hit"
    aFile=File.new("log.txt","a+")
    aFile.puts(@entry)
    aFile.close
  end
  
  def make_delete_entry(timestamp,address)
    @entry= "#{timestamp.to_s} #{address} evicted"
    aFile=File.new("log.txt","a+")
    aFile.puts(@entry)
    aFile.close
  end
  
  def make_miss_entry(timestamp,address)
    @entry="#{timestamp.to_s} #{address} cache miss"
    aFile=File.new("log.txt","a+")
    aFile.puts(@entry)
    aFile.close
  end
  
  def make_exit_entry(timestamp,hits,miss)
    @entry="#{timestamp.to_s} total hits: #{hits.to_s}\n#{timestamp.to_s} total misses: #{miss.to_s}\n"
    aFile=File.new("log.txt","a+")
    aFile.puts(@entry)
    aFile.close
  end
end
#class Webpage
  
  #def initialize(address,filename,timestamp)
    #@page_address=address
   # @page_timestamp=timestamp
  #  @page_filename=filename
 # end
#end

#EXECUTION of the program starts here

server=ProxyServer.new
server.start()

while (url = gets) != "\n"
  puts "Enter the url: Or Press Enter twice to EXIT"
  server.request(url.strip)  
end

server.stop()