#!/usr/bin/env ruby

require 'optparse'
require 'open-uri'
require 'ostruct'
require 'csv'

OK = 0
WARNING = 1
CRITICAL = 2

WARNING_PRECENTAGE = 0.8
CIRTICAL_PRECENTAGE = 0.9


HAPROXY_COLUMN_NAMES = %w{pxname svname qcur qmax scur smax slim stot bin bout dreq dresp ereq econ eresp wretr wredis status weight act bck chkfail chkdown lastchg downtime qlimit pid iid sid throttle lbtot tracked type rate rate_lim rate_max check_status check_code check_duration hrsp_1xx hrsp_2xx hrsp_3xx hrsp_4xx hrsp_5xx hrsp_other hanafail req_rate req_rate_max req_tot cli_abrt srv_abrt}

@messages = []
@graphs = []
exit_code = OK

options = OpenStruct.new
options.proxies = []

opts = OptionParser.new
  # Required arguments

opts.on("-u", "--url URL", "csv-formatted stats URL to check (http://demo.1wt.eu/;csv") do |v|
  options.url = v
end

# Optional Arguments

opts.on("-p", "--proxies [PROXIES]", "Only check these proxies (eg proxy1,proxy2,proxylive)") do |v|
  options.proxies = v.split(/,/)
end

opts.on("-U", "--user [USER]", "basic auth USER to login as") do |v|
  options.user = v
end

opts.on("-P", "--password [PASSWORD]", "basic auth PASSWORD") do |v|
  options.password = v
end

opts.on("-d", "--[no-]debug", "include debug output") do |v|
  options.debug = v
end

opts.on( '-h', '--help', 'Display this screen' ) do
  puts opts
  exit 3
end
opts.parse!

if !options.url
  puts "ERROR: URL is required"
  puts opts
  exit
end

open(options.url, :http_basic_authentication => [options.user, options.password]) do |f|
  f.each do |line|

    row = HAPROXY_COLUMN_NAMES.zip(CSV.parse(line)[0]).reduce({}) { |hash, val| hash.merge({val[0] => val[1]}) }

    next unless options.proxies.empty? || options.proxies.include?(row['pxname'])
    next if row['svname'] == 'BACKEND'
    next if row['svname'] == 'svname' 

 
    graph_warn = row['slim'].to_f * WARNING_PRECENTAGE
    graph_crit = row['slim'].to_f * CIRTICAL_PRECENTAGE
    if row['scur'].to_f > graph_crit then
	    temp = "Critical"
	    exit_code = 2
    elsif row['scur'].to_f > graph_warn then
	    temp = "Warning"
	    if exit_code > 1 then
		    exit_code = 1
	    end		    
    else 
	    temp = "Ok"	    
    end 
    if row['svname'] == 'FRONTEND' then
 	message = sprintf("%s: %s %s has %s current connections and a limit of %s", temp, row['pxname'], row['svname'], row['scur'], row['slim'])
	unique_name=row['pxname'] << row['svname']
    else
	message = sprintf("%s: %s has %s current connections and a limit of %s for %s proxy. ",temp, row['svname'], row['scur'], row['slim'], row['pxname'])
	unique_name=row['svname'] << row['pxname']
    end
    graph = sprintf("connections %s=%s;%s;%s;0 ",unique_name,row['scur'].to_f,graph_warn,graph_crit)


    @messages << message 
    @graphs << graph
  end
end

if @messages.length == 0
  exit_code = WARNING
  puts "No proxies listed as up or down"
else
  # output DOWN messages on a single line
  down_proxies = @messages.reject { |m| m.match(/Ok:/) }

  if down_proxies.length > 0
    puts down_proxies.join(" ")
  else
    puts "All proxies OK"
  end
  print " | "  
  print @graphs
end

exit exit_code

=begin
Copyright (C) 2013 Ben Prew

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
=end
