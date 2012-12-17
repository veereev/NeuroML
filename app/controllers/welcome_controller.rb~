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
    @projects = Project.latest User.current
  end
  def other_workshop
    @projects = Project.latest User.current
  end
 #===================== End of Home Menu============

 #===================Documents Menu================
 def introduction
    @projects = Project.latest User.current
 end
 def level1
    @projects = Project.latest User.current
 end
 def level2
     @projects = Project.latest User.current
 end
 def level3
    @projects = Project.latest User.current
 end
 def extend_neuroml
    @projects = Project.latest User.current
 end
 def alpha_schema
    @projects = Project.latest User.current
 end
 def lems_dev
    @projects = Project.latest User.current
 end
 def libnml
    @projects = Project.latest User.current
 end
 def sbml
     @projects = Project.latest User.current 
 end
 def nineml

     @projects = Project.latest User.current 
 end
 def cellml
     @projects = Project.latest User.current 
 end
 def lems
    @projects = Project.latest User.current 
 end
 def relevant_publications
    @projects = Project.latest User.current
 end
 def abstracts
    @projects = Project.latest User.current
 end
 def presentations
    @projects = Project.latest User.current
 end
#=========================== End of Documents Menu ===============

#============================ Examples menu =====================
 def level1_eg
    @projects = Project.latest User.current
 end
 def level2_eg
    @projects = Project.latest User.current
 end
 def level3_eg
    @projects = Project.latest User.current
 end
 def level4_eg
    @projects = Project.latest User.current
 end
#========================= End of Examples Menu ==================
#===================== Tools Menu ==============
 def current_app_support
    @projects = Project.latest User.current
 end
 def planning_support
    @projects = Project.latest User.current
 end
 def neuron_tools
    @projects = Project.latest User.current
 end
 def pynn
    @projects = Project.latest User.current
 end
 def x3dtools
    @projects = Project.latest User.current
 end
#===================== End of Tools Menu ==============


#==================== Models=============
 def models
    @projects = Project.latest User.current
 end
#======================End of Models======

#=====================Validators Menu ========================
 def validate
    @projects = Project.latest User.current
 end
 def latest_release_notes
    @projects = Project.latest User.current
 end
#=======================End of Validators Menu ===============

#========================= Community Menu ===========
 def development
    @projects = Project.latest User.current
 end
 def contributors
    @projects = Project.latest User.current
 end
 def brief_history
    @projects = Project.latest User.current
 end
 def standard_proj_biosciences
    @projects = Project.latest User.current
 end
 def db_proj
    @projects = Project.latest User.current
 end
 def general_info_xmltools
    @projects = Project.latest User.current
 end
#=========================== End of Community Menu ===========
#============================ Contact Menu====================
 def contacts
    @projects = Project.latest User.current
 end
 def acknowledgements
    @projects = Project.latest User.current
 end
#============================ End of Contacts Menu =============

end  

