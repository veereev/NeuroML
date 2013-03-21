# Copyright (C) 2006-2012  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class WelcomeController < ApplicationController
  caches_action :robots
def python_test
puts params[:q];
parser_text=params[:q]
@resultset=`/usr/bin/python /tmp/test.py`;
puts @resultset
logger.info "\n\n\n"+@resultset+"\n\n\n"
connection = ActiveRecord::Base.connection();
#@resultset = connection.execute("select id,type from users where id=2")
#puts @results.id
end  
  def index
    @news = News.latest User.current
    @projects = Project.latest User.current
   #render :layout => 'homepage'
     end
 def mission
 end

 def model_info
@model_id=params[:model_id].to_s
substring=@model_id[0..4]
if substring ==  "NMLCL"
cell=Cell.find_by_Cell_ID(@model_id.to_s)
@name=cell.Cell_Name
@type="Cell"
@file=cell.MorphML_File
end

if substring == "NMLCH"
channel=Channel.find_by_Channel_ID(@model_id.to_s)
@name=channel.Channel_Name
@type="Channel"
@file=channel.ChannelML_File
end


if substring == "NMLNT"
network=Network.find_by_Network_ID(@model_id.to_s)
@name=network.Network_Name
@type="Network"
@file=network.NetworkML_File
end

#if substring == "NMLSY"
#synapse=Synapse.find_by_Synapse_ID(@model_id.to_s)
#@name=synapse.Synapse_Name
#@type="Syanpse"
#@file=synapse.SynapseML_File
#end

 end


def search_process_test
render :text => params[:q].to_s
end
def search_python
search_text=params[:q]
@resultset=`/usr/bin/python /tmp/Neurolex_py/pseudo_main.py #{search_text}`
puts 'getting stuff'
puts search_text
if @resultset.to_s.length == 0
render :text => "No Results Found" and return
end

puts @resultset.to_s
resultstring=@resultset.to_s
indexdiff = 0

indexdiff=resultstring.index('}') - resultstring.index('{')

if indexdiff != 1 

cleanstring=resultstring[resultstring.index('{')..resultstring.index(']}')+1]
cleanstring=cleanstring.gsub(':','=>')
@result_hash=eval(cleanstring)

@ont_headers=Array.new
@ont_ids=Array.new
@ont_names=Array.new
@ont_types=Array.new
for key,value in @result_hash
@ont_headers.push(key)
temparray=value.to_a
 for eachid in temparray
 substring=eachid[0..4]
puts"\n\n************"+substring
if substring ==  "NMLCL"
cell=Cell.find_by_Cell_ID(eachid.to_s)
name=cell.Cell_Name
type="Cell"
end

if substring == "NMLCH"
channel=Channel.find_by_Channel_ID(eachid.to_s)
name=channel.Channel_Name
type="Channel"
end


if substring == "NMLNT"
network=Network.find_by_Network_ID(eachid.to_s)
name=network.Network_Name
type="Network"
end

#if substring == "NMLSY"
#name=Synapse.find_by_Synapse_ID(eachid.to_s)
#type="Syanpse"
#end
@ont_ids.push(eachid)
@ont_names.push(name)
@ont_types.push(type)  
 end

end
end

if   indexdiff != 1
render :partial => 'ontology_search_results', :locals => {:ont_ids=>@ont_ids,:ont_names=>@ont_names,:ont_types=>@ont_types,:result_hash=>@result_hash}
else
render :text => 'No Results Found'
end
end






 def search_process

search_text=params[:q].to_s
all=params[:all].to_s
exact=params[:exact].to_s
any=params[:any].to_s
none=params[:none].to_s
advanced_query=""

if all != ""
all=all.split(' ')
all_like=all.map {|x| "keyword like " + "'%" + x + "%'" }
all_like=all_like.join(' and ')
advanced_query=all_like
end

if exact != "" && all != ""
exact="'%"+exact+"%'"
advanced_query = advanced_query + " and keyword like " + exact
end

if exact != "" && all == ""
exact="'%"+exact+"%'"
advanced_query = "keyword like " + exact
end

if any != "" and ( all != "" or exact != "" )
any=any.split(' ')
any_like=any.map { |x| "keyword like " + "'%" + x + "%'" }
any_like=any_like.join(' or ')
advanced_query = advanced_query + " and (" + any_like + ")"
end

if any != "" and all == "" and exact == ""
any=any.split(' ')
any_like=any.map { |x| "keyword like " + "'%" + x + "%'" }
any_like=any_like.join(' or ')
advanced_query = "(" + any_like + ")"
end

if none != "" and (all != "" or exact != "" or any != "")
none=none.split(' ')
none_not_like=none.map { |x| "keyword not like " + "'%" + x + "%'" }

none_not_like=none_not_like.join(' and ') 

advanced_query=advanced_query + " and " + none_not_like

end

if none != "" and all == "" and exact == "" and any == ""
none=none.split(' ')
none_not_like=none.map { |x| "keyword not like " + "'%" + x + "%'" }

none_not_like=none_not_like.join(' and ') 

advanced_query= none_not_like
end





advanced_query = "SELECT Model_ID FROM keyword_symbol_tables WHERE "+advanced_query
puts "\n\n***********************************\n\n"+advanced_query+"\n\n**********************\n\n"

parameter_search_text=search_text.split.join(" ")
 keyword_array=parameter_search_text.split(' ')
 keyword_count=keyword_array.size
 #@search_keywords_array=@search_text.split(/,|\sor\s|\sand\s|\snot\s/).map(&:strip).reject(&:empty?)
#ActiveRecord::Base.pluralize_table_names = false
connection = ActiveRecord::Base.connection();
if all != "" or exact != "" or any != "" or none != ""
@resultset = connection.execute("#{advanced_query}");
else
@resultset = connection.execute("call keyword_search('#{parameter_search_text}',#{keyword_count})");
end
ActiveRecord::Base.clear_active_connections!()

@resultset.each do |res|
puts res
end
@resultset_strings = @resultset.map { |result| result.to_s.gsub(/[^0-9A-Za-z]/, '')}
@model_ids=Array.new
@model_names=Array.new
@model_types=Array.new
@resultset_strings.each do |result|
substring=result[0..4]
puts"\n\n************"+substring
if substring ==  "NMLCL"
cell=Cell.find_by_Cell_ID(result.to_s)
name=cell.Cell_Name
type="Cell"
end

if substring == "NMLCH"
channel=Channel.find_by_Channel_ID(result.to_s)
name=channel.Channel_Name
type="Channel"
end


if substring == "NMLNT"
network=Network.find_by_Network_ID(result.to_s)
name=network.Network_Name
type="Network"
end

#if substring == "NMLSY"
#name=Synapse.find_by_Synapse_ID(result.to_s)
#type="Syanpse"
#end

@model_ids.push(result)
@model_names.push(name)
@model_types.push(type)
puts "result-"+result+"name-"+name.to_s
end

if @model_ids.count != 0
render :partial => 'keyword_results_list',:locals => {:model_ids => @model_ids,:model_names => @model_names,:model_types => @model_types}
else
render :text => 'No Results Found'
end


 end



 def search_result
render :layout => 'temp'
 end
  def robots
    @projects = Project.all_public.active
    render :layout => false, :content_type => 'text/plain'
  end
  
 #===================Home Menu=====================
  def welcome
    @projects = Project.latest User.current
   render :layout => 'homepage'
  end
  def  neuro_workshop

  end
  def other_workshop

  end
  def workshop2012

  end
 #===================== End of Home Menu============

 #===================Documents Menu================
 def introduction

 end
 def specifications
end
 def level1

 end
 def level2

 end
 def level3

 end
 def extend_neuroml

 end
 def alpha_schema

 end
 def lems_dev

 end
 def libnml

 end
 def sbml

 end
 def nineml


 end
 def cellml

 end
 def lems
render :layout => 'temp'
 end
 def relevant_publications

 end
 def abstracts

 end
 def presentations

 end
 def workshop2009

 end
 def workshop2010
 
 end
 def workshop2011
 
 end
 def workshop2012
 
 end
#=========================== End of Documents Menu ===============
 def history

 end
#============================ Examples menu =====================
 def level1_eg

 end
 def level2_eg

 end
 def level3_eg

 end
 def level4_eg

 end
#========================= End of Examples Menu ==================
#===================== Tools Menu ==============
 def current_app_support

 end
 def planning_support

 end
 def neuron_tools

 end
 def pynn

 end
 def x3dtools

 end
#===================== End of Tools Menu ==============


#==================== Models=============
 def models

 end
#======================End of Models======

#=====================Validators Menu ========================
 def validate

 end
 def latest_release_notes

 end
#=======================End of Validators Menu ===============

#========================= Community Menu ===========
 def development

 end
 def scientific_committee

 end
 def brief_history

 end
 def standard_proj_biosciences

 end
 def db_proj

 end
 def general_info_xmltools

 end
#=========================== End of Community Menu ===========
#============================ Contact Menu====================
 def contacts

 end
 def acknowledgements

 end
#============================ End of Contacts Menu =============

end  
#====================Lems==========================
def lems_intro
end
def lems_elements
end
def lems_download
end
def lems_example1
end
def lems_example2
end
def lems_example3
end
def lems_example4
end
def lems_example5
end
def lems_example6
end
def lems_example7
end
def lems_example_regimes
end
def lems_example_n
end
def lems_canonical
end
def lems_discussion
end
#============== End of Lems ======================
