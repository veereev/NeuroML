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
   # render :layout => 'application'
     end

  def robots
    @projects = Project.all_public.active
    render :layout => false, :content_type => 'text/plain'
  end
  
  #===================Home Menu=====================
  def welcome
    @projects = Project.latest User.current
  end
  def  neuro_workshop
render :layout => 'other_pages'
  end
  def other_workshop
render :layout => 'other_pages'
  end
  def workshop2012
render :layout => 'other_pages'
  end
 #===================== End of Home Menu============

 #===================Documents Menu================
 def introduction
render :layout => 'other_pages'
  
 end
 def level1
render :layout => 'other_pages'
 end
 def level2
render :layout => 'other_pages'
 end
 def level3
render :layout => 'other_pages'
 end
 def extend_neuroml
render :layout => 'other_pages'
 end
 def alpha_schema
render :layout => 'other_pages'
 end
 def lems_dev
render :layout => 'other_pages'
 end
 def libnml
render :layout => 'other_pages'
 end
 def sbml
render :layout => 'other_pages'
 end
 def nineml

render :layout => 'other_pages'
 end
 def cellml
render :layout => 'other_pages'
 end
 def lems
render :layout => 'other_pages'
 end
 def relevant_publications
render :layout => 'other_pages'
 end
 def abstracts
render :layout => 'other_pages'
 end
 def presentations
render :layout => 'other_pages'
 end
 def workshop2011
render :layout => 'other_pages'
 end
#=========================== End of Documents Menu ===============
 def history
render :layout => 'other_pages'
 end
#============================ Examples menu =====================
 def level1_eg
render :layout => 'other_pages'
 end
 def level2_eg
render :layout => 'other_pages'
 end
 def level3_eg
render :layout => 'other_pages'
 end
 def level4_eg
render :layout => 'other_pages'
 end
#========================= End of Examples Menu ==================
#===================== Tools Menu ==============
 def current_app_support
render :layout => 'other_pages'
 end
 def planning_support
render :layout => 'other_pages'
 end
 def neuron_tools
render :layout => 'other_pages'
 end
 def pynn
render :layout => 'other_pages'
 end
 def x3dtools
render :layout => 'other_pages'
 end
#===================== End of Tools Menu ==============


#==================== Models=============
 def models
render :layout => 'other_pages'
 end
#======================End of Models======

#=====================Validators Menu ========================
 def validate
render :layout => 'other_pages'
 end
 def latest_release_notes
render :layout => 'other_pages'
 end
#=======================End of Validators Menu ===============

#========================= Community Menu ===========
 def development
render :layout => 'other_pages'
 end
 def scientific_committee
render :layout => 'other_pages'
 end
 def brief_history
render :layout => 'other_pages'
 end
 def standard_proj_biosciences
render :layout => 'other_pages'
 end
 def db_proj
render :layout => 'other_pages'
 end
 def general_info_xmltools
render :layout => 'other_pages'
 end
#=========================== End of Community Menu ===========
#============================ Contact Menu====================
 def contacts
render :layout => 'other_pages'
 end
 def acknowledgements
render :layout => 'other_pages'
 end
#============================ End of Contacts Menu =============

end  

