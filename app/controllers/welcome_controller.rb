# Redmine - project management software
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
  
  def index
    @news = News.latest User.current
    @projects = Project.latest User.current
   #render :layout => 'homepage'
     end
 def mission
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
