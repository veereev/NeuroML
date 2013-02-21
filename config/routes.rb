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

RedmineApp::Application.routes.draw do
  root :to => 'welcome#index', :as => 'home'
  match 'home', :to  => 'welcome#index', :as => 'home'
  match 'neuro_workshop', :to => 'welcome#neuro_workshop', :as => 'neuro_workshop'
  match 'python_test', :to => 'welcome#python_test', :as => 'python_test'
  match 'other_workshop', :to => 'welcome#other_workshop', :as => 'other_workshop'
  match 'workshops', :to => 'welcome#workshops', :as => 'workshops'
  match 'workshop2011', :to => 'welcome#workshop2011', :as => 'workshop2011'
  match 'workshop2012', :to => 'welcome#workshop2012', :as => 'workshop2012'
  match 'workshop2010', :to => 'welcome#workshop2010', :as => 'workshop2010'
  match 'workshop2009', :to => 'welcome#workshop2009', :as => 'workshop2009'
  match 'CNS_workshop', :to => 'welcome#CNS_workshop', :as => 'CNS_workshop'
  match 'introduction', :to => 'welcome#introduction', :as => 'introduction'
  match 'newsevents', :to => 'welcome#news_events', :as => 'newsevents'
  match 'level1', :to => 'welcome#level1', :as => 'level1'
  match 'level2', :to => 'welcome#level2', :as => 'level2'
  match 'level3', :to => 'welcome#level3', :as => 'level3'
  match 'extend_neuroml', :to => 'welcome#extend_neuroml', :as => 'extend_neuroml'
  match 'neuromlv2' , :to => 'welcome#neuromlv2', :as => 'neuromlv2'
  match 'alpha_schema', :to => 'welcome#alpha_schema', :as => 'alpha_schema'
  match 'lems_dev', :to => 'welcome#lems_dev', :as => 'lems_dev'
  match 'libnml', :to => 'welcome#libnml', :as => 'libnml'
  match 'compatibility', :to => 'welcome#compatibility', :as => 'compatibility'
  match 'lems', :to => 'welcome#lems', :as => 'lems'
  match 'relevant_publications', :to => 'welcome#relevant_publications', :as => 'relevant_publications'
  match 'abstracts', :to => 'welcome#abstracts', :as => 'abstracts'
  match 'presentations', :to => 'welcome#presentations', :as=> 'presentations'
  match 'examples', :to => 'welcome#examples', :as => 'examples'
  match 'level1_eg', :to => 'welcome#level1_eg', :as => 'level1_eg'
  match 'level2_eg', :to => 'welcome#level2_eg', :as => 'level2_eg'
  match 'level3_eg', :to => 'welcome#level3_eg', :as => 'level3_eg'
  match 'level4_eg', :to => 'welcome#level4_eg', :as => 'level4_eg'
  match 'tool_support', :to => 'welcome#tool_support', :as => 'tool_support'
  match 'current_app_support', :to => 'welcome#current_app_support', :as => 'current_app_support'
  match 'planning_support', :to => 'welcome#planning_support', :as => 'planning_support'
  match 'neuron_tools', :to => 'welcome#neuron_tools', :as => 'neuron_tools'
  match 'pynn', :to => 'welcome#pynn', :as => 'pynn'
  match 'x3dtools', :to => 'welcome#x3dtools', :as => 'pynn'
  match 'models', :to => 'welcome#models', :as => 'models'
  match 'browse_models', :to => 'welcome#browse_models', :as => 'browse_models'
  match 'model_submit', :to => 'welcome#model_submit', :as => 'model_submit'
  match 'validate', :to => 'welcome#validate', :as => 'validate'
  match 'latest_release_notes', :to => 'welcome#latest_release_notes', :as => 'latest_release_notes'
  match 'development', :to => 'welcome#development', :as => 'development'
  match 'scientific_committee', :to => 'welcome#scientific_committee', :as => 'scientific_committee'
  match 'contributors', :to => 'welcome#contributors', :as => 'contributors'
  match 'brief_history', :to => 'welcome#brief_history', :as => 'brief_history'
  match 'standard_proj_biosciences', :to => 'welcome#standard_proj_biosciences', :as => 'standard_proj_biosciences'
  match 'history', :to=>'welcome#history', :as => 'history'
  match 'db_proj', :to => 'welcome#db_proj', :as => 'db_proj'
  match 'general_info_xmltools', :to => 'welcome#general_info_xmltools', :as => 'general_info_xmltools'
  match 'contacts', :to => 'welcome#contacts', :as => 'contacts'
  match 'acknowledgements', :to => 'welcome#acknowledgements', :as => 'acknowledgements'
  match 'cellml', :to => 'welcome#cellml', :as => 'cellml'
  match 'nineml', :to => 'welcome#nineml', :as => 'nineml'
  match 'sbml', :to => 'welcome#sbml', :as => 'sbml'
  match 'login', :to => 'account#login', :as => 'signin'
  match 'logout', :to => 'account#logout', :as => 'signout'
  match 'search_result', :to => 'welcome#search_result', :as => 'search_result'
 match 'search_process', :to => 'welcome#search_process', :as => 'search_process'  
match 'mission', :to => 'welcome#mission', :as => 'mission'
   match 'register', :to => 'account#register', :via => [:get, :post], :as => 'register'
   match 'workshop2009', :to => 'welcome#workshop2009', :as => 'workshop2009'
   match 'workshop2010', :to => 'welcome#workshop2010', :as => 'workshop2010'
   match 'workshop2011', :to => 'welcome#workshop2011', :as => 'workshop2011'
   match 'workshop2012', :to => 'welcome#workshop2012', :as => 'workshop2012'
  match 'lems_intro', :to => 'welcome#lems_intro', :as => 'lems_intro'
  match 'lems_elements', :to => 'welcome#lems_elements', :as => 'lems_elements'
  match 'specifications', :to => 'welcome#specifications', :as => 'specifications'
  match 'lems_download', :to => 'welcome#lems_download', :as => 'lems_download'
  match 'lems_example1', :to => 'welcome#lems_example1', :as => 'lems_example1' 
  match 'lems_example2', :to => 'welcome#lems_example2', :as => 'lems_example2'
  match 'lems_example3', :to => 'welcome#lems_example3', :as => 'lems_example3'
  match 'lems_example4', :to => 'welcome#lems_example4', :as => 'lems_example4'
  match 'lems_example5', :to => 'welcome#lems_example5', :as => 'lems_example5'
  match 'lems_example6', :to => 'welcome#lems_example6', :as => 'lems_example6'
  match 'lems_example7', :to => 'welcome#lems_example7', :as => 'lems_example7'
  match 'lems_example_regimes', :to => 'welcome#lems_example_regimes', :as => 'lems_example_regimes'
  match 'lems_example_n', :to => 'welcome#lems_example_n', :as => 'lems_example_n'
  match 'lems_neuroml2', :to => 'welcome#lems_neuroml2', :as => 'lems_neuroml2'
  match 'lems_canonical', :to => 'welcome#lems_canonical', :as => 'lems_canonical'
  match 'lems_discussion', :to => 'welcome#lems_discussion', :as => 'lems_discussion'
  match 'lems_interpreter', :to => 'welcome#lems_interpreter', :as => 'lems_interpreter'
 #match 'account/register', :to => 'account#register', :via => [:get, :post], :as => 'register'
  match 'account/lost_password', :to => 'account#lost_password', :via => [:get, :post], :as => 'lost_password'
  match 'account/activate', :to => 'account#activate', :via => :get
  
  match '/news/preview', :controller => 'previews', :action => 'news', :as => 'preview_news'
  match '/issues/preview/new/:project_id', :to => 'previews#issue', :as => 'preview_new_issue'
  match '/issues/preview/edit/:id', :to => 'previews#issue', :as => 'preview_edit_issue'
  match '/issues/preview', :to => 'previews#issue', :as => 'preview_issue'

  match 'projects/:id/wiki', :to => 'wikis#edit', :via => :post
  match 'projects/:id/wiki/destroy', :to => 'wikis#destroy', :via => [:get, :post]

  match 'boards/:board_id/topics/new', :to => 'messages#new', :via => [:get, :post]
  get 'boards/:board_id/topics/:id', :to => 'messages#show', :as => 'board_message'
  match 'boards/:board_id/topics/quote/:id', :to => 'messages#quote', :via => [:get, :post]
  get 'boards/:board_id/topics/:id/edit', :to => 'messages#edit'

  post 'boards/:board_id/topics/preview', :to => 'messages#preview'
  post 'boards/:board_id/topics/:id/replies', :to => 'messages#reply'
  post 'boards/:board_id/topics/:id/edit', :to => 'messages#edit'
  post 'boards/:board_id/topics/:id/destroy', :to => 'messages#destroy'

  # Misc issue routes. TODO: move into resources
  match '/issues/auto_complete', :to => 'auto_completes#issues', :via => :get, :as => 'auto_complete_issues'
  match '/issues/context_menu', :to => 'context_menus#issues', :as => 'issues_context_menu'
  match '/issues/changes', :to => 'journals#index', :as => 'issue_changes'
  match '/issues/:id/quoted', :to => 'journals#new', :id => /\d+/, :via => :post, :as => 'quoted_issue'

  match '/journals/diff/:id', :to => 'journals#diff', :id => /\d+/, :via => :get
  match '/journals/edit/:id', :to => 'journals#edit', :id => /\d+/, :via => [:get, :post]

  match '/projects/:project_id/issues/gantt', :to => 'gantts#show'
  match '/issues/gantt', :to => 'gantts#show'

  match '/projects/:project_id/issues/calendar', :to => 'calendars#show'
  match '/issues/calendar', :to => 'calendars#show'

  match 'projects/:id/issues/report', :to => 'reports#issue_report', :via => :get
  match 'projects/:id/issues/report/:detail', :to => 'reports#issue_report_details', :via => :get

  match 'my/account', :controller => 'my', :action => 'account', :via => [:get, :post]
  match 'my/account/destroy', :controller => 'my', :action => 'destroy', :via => [:get, :post]
  match 'my/page', :controller => 'my', :action => 'page', :via => :get
  match 'my', :controller => 'my', :action => 'index', :via => :get # Redirects to my/page
  match 'my/reset_rss_key', :controller => 'my', :action => 'reset_rss_key', :via => :post
  match 'my/reset_api_key', :controller => 'my', :action => 'reset_api_key', :via => :post
  match 'my/password', :controller => 'my', :action => 'password', :via => [:get, :post]
  match 'my/page_layout', :controller => 'my', :action => 'page_layout', :via => :get
  match 'my/add_block', :controller => 'my', :action => 'add_block', :via => :post
  match 'my/remove_block', :controller => 'my', :action => 'remove_block', :via => :post
  match 'my/order_blocks', :controller => 'my', :action => 'order_blocks', :via => :post

  resources :users
  match 'users/:id/memberships/:membership_id', :to => 'users#edit_membership', :via => :put, :as => 'user_membership'
  match 'users/:id/memberships/:membership_id', :to => 'users#destroy_membership', :via => :delete
  match 'users/:id/memberships', :to => 'users#edit_membership', :via => :post, :as => 'user_memberships'

  match 'watchers/new', :controller=> 'watchers', :action => 'new', :via => :get
  match 'watchers', :controller=> 'watchers', :action => 'create', :via => :post
  match 'watchers/append', :controller=> 'watchers', :action => 'append', :via => :post
  match 'watchers/destroy', :controller=> 'watchers', :action => 'destroy', :via => :post
  match 'watchers/watch', :controller=> 'watchers', :action => 'watch', :via => :post
  match 'watchers/unwatch', :controller=> 'watchers', :action => 'unwatch', :via => :post
  match 'watchers/autocomplete_for_user', :controller=> 'watchers', :action => 'autocomplete_for_user', :via => :get

  match 'projects/:id/settings/:tab', :to => "projects#settings"

  resources :projects do
    member do
      get 'settings'
      post 'modules'
      post 'archive'
      post 'unarchive'
      post 'close'
      post 'reopen'
      match 'copy', :via => [:get, :post]
    end

    resources :memberships, :shallow => true, :controller => 'members', :only => [:index, :show, :create, :update, :destroy] do
      collection do
        get 'autocomplete'
      end
    end

    resource :enumerations, :controller => 'project_enumerations', :only => [:update, :destroy]

    match 'issues/:copy_from/copy', :to => 'issues#new'
    resources :issues, :only => [:index, :new, :create] do
      resources :time_entries, :controller => 'timelog' do
        collection do
          get 'report'
        end
      end
    end
    # issue form update
    match 'issues/new', :controller => 'issues', :action => 'new', :via => [:put, :post], :as => 'issue_form'

    resources :files, :only => [:index, :new, :create]

    resources :versions, :except => [:index, :show, :edit, :update, :destroy] do
      collection do
        put 'close_completed'
      end
    end
    match 'versions.:format', :to => 'versions#index'
    match 'roadmap', :to => 'versions#index', :format => false
    match 'versions', :to => 'versions#index'

    resources :news, :except => [:show, :edit, :update, :destroy]
    resources :time_entries, :controller => 'timelog' do
      get 'report', :on => :collection
    end
    resources :queries, :only => [:new, :create]
    resources :issue_categories, :shallow => true
    resources :documents, :except => [:show, :edit, :update, :destroy]
    resources :boards
    resources :repositories, :shallow => true, :except => [:index, :show] do
      member do
        match 'committers', :via => [:get, :post]
      end
    end

    match 'wiki/index', :controller => 'wiki', :action => 'index', :via => :get
    match 'wiki/:id/diff/:version/vs/:version_from', :controller => 'wiki', :action => 'diff'
    match 'wiki/:id/diff/:version', :controller => 'wiki', :action => 'diff'
    resources :wiki, :except => [:index, :new, :create] do
      member do
        get 'rename'
        post 'rename'
        get 'history'
        get 'diff'
        match 'preview', :via => [:post, :put]
        post 'protect'
        post 'add_attachment'
      end
      collection do
        get 'export'
        get 'date_index'
      end
    end
    match 'wiki', :controller => 'wiki', :action => 'show', :via => :get
    match 'wiki/:id/annotate/:version', :controller => 'wiki', :action => 'annotate'
  end

  resources :issues do
    collection do
      match 'bulk_edit', :via => [:get, :post]
      post 'bulk_update'
    end
    resources :time_entries, :controller => 'timelog' do
      collection do
        get 'report'
      end
    end
    resources :relations, :shallow => true, :controller => 'issue_relations', :only => [:index, :show, :create, :destroy]
  end
  match '/issues', :controller => 'issues', :action => 'destroy', :via => :delete

  resources :queries, :except => [:show]

  resources :news, :only => [:index, :show, :edit, :update, :destroy]
  match '/news/:id/comments', :to => 'comments#create', :via => :post
  match '/news/:id/comments/:comment_id', :to => 'comments#destroy', :via => :delete

  resources :versions, :only => [:show, :edit, :update, :destroy] do
    post 'status_by', :on => :member
  end

  resources :documents, :only => [:show, :edit, :update, :destroy] do
    post 'add_attachment', :on => :member
  end

  match '/time_entries/context_menu', :to => 'context_menus#time_entries', :as => :time_entries_context_menu

  resources :time_entries, :controller => 'timelog', :except => :destroy do
    collection do
      get 'report'
      get 'bulk_edit'
      post 'bulk_update'
    end
  end
  match '/time_entries/:id', :to => 'timelog#destroy', :via => :delete, :id => /\d+/
  # TODO: delete /time_entries for bulk deletion
  match '/time_entries/destroy', :to => 'timelog#destroy', :via => :delete

  # TODO: port to be part of the resources route(s)
  match 'projects/:id/settings/:tab', :to => 'projects#settings', :via => :get

  get 'projects/:id/activity', :to => 'activities#index'
  get 'projects/:id/activity.:format', :to => 'activities#index'
  get 'activity', :to => 'activities#index'

  # repositories routes
  get 'projects/:id/repository/:repository_id/statistics', :to => 'repositories#stats'
  get 'projects/:id/repository/:repository_id/graph', :to => 'repositories#graph'

  get 'projects/:id/repository/:repository_id/changes(/*path(.:ext))',
      :to => 'repositories#changes'

  get 'projects/:id/repository/:repository_id/revisions/:rev', :to => 'repositories#revision'
  get 'projects/:id/repository/:repository_id/revision', :to => 'repositories#revision'
  post   'projects/:id/repository/:repository_id/revisions/:rev/issues', :to => 'repositories#add_related_issue'
  delete 'projects/:id/repository/:repository_id/revisions/:rev/issues/:issue_id', :to => 'repositories#remove_related_issue'
  get 'projects/:id/repository/:repository_id/revisions', :to => 'repositories#revisions'
  get 'projects/:id/repository/:repository_id/revisions/:rev/:action(/*path(.:ext))',
      :controller => 'repositories',
      :format => false,
      :constraints => {
            :action => /(browse|show|entry|raw|annotate|diff)/,
            :rev    => /[a-z0-9\.\-_]+/
          }

  get 'projects/:id/repository/statistics', :to => 'repositories#stats'
  get 'projects/:id/repository/graph', :to => 'repositories#graph'

  get 'projects/:id/repository/changes(/*path(.:ext))',
      :to => 'repositories#changes'

  get 'projects/:id/repository/revisions', :to => 'repositories#revisions'
  get 'projects/:id/repository/revisions/:rev', :to => 'repositories#revision'
  get 'projects/:id/repository/revision', :to => 'repositories#revision'
  post   'projects/:id/repository/revisions/:rev/issues', :to => 'repositories#add_related_issue'
  delete 'projects/:id/repository/revisions/:rev/issues/:issue_id', :to => 'repositories#remove_related_issue'
  get 'projects/:id/repository/revisions/:rev/:action(/*path(.:ext))',
      :controller => 'repositories',
      :format => false,
      :constraints => {
            :action => /(browse|show|entry|raw|annotate|diff)/,
            :rev    => /[a-z0-9\.\-_]+/
          }
  get 'projects/:id/repository/:repository_id/:action(/*path(.:ext))',
      :controller => 'repositories',
      :action => /(browse|show|entry|raw|changes|annotate|diff)/
  get 'projects/:id/repository/:action(/*path(.:ext))',
      :controller => 'repositories',
      :action => /(browse|show|entry|raw|changes|annotate|diff)/

  get 'projects/:id/repository/:repository_id', :to => 'repositories#show', :path => nil
  get 'projects/:id/repository', :to => 'repositories#show', :path => nil

  # additional routes for having the file name at the end of url
  match 'attachments/:id/:filename', :controller => 'attachments', :action => 'show', :id => /\d+/, :filename => /.*/, :via => :get
  match 'attachments/download/:id/:filename', :controller => 'attachments', :action => 'download', :id => /\d+/, :filename => /.*/, :via => :get
  match 'attachments/download/:id', :controller => 'attachments', :action => 'download', :id => /\d+/, :via => :get
  match 'attachments/thumbnail/:id(/:size)', :controller => 'attachments', :action => 'thumbnail', :id => /\d+/, :via => :get, :size => /\d+/
  resources :attachments, :only => [:show, :destroy]

  resources :groups do
    member do
      get 'autocomplete_for_user'
    end
  end

  match 'groups/:id/users', :controller => 'groups', :action => 'add_users', :id => /\d+/, :via => :post, :as => 'group_users'
  match 'groups/:id/users/:user_id', :controller => 'groups', :action => 'remove_user', :id => /\d+/, :via => :delete, :as => 'group_user'
  match 'groups/destroy_membership/:id', :controller => 'groups', :action => 'destroy_membership', :id => /\d+/, :via => :post
  match 'groups/edit_membership/:id', :controller => 'groups', :action => 'edit_membership', :id => /\d+/, :via => :post

  resources :trackers, :except => :show do
    collection do
      match 'fields', :via => [:get, :post]
    end
  end
  resources :issue_statuses, :except => :show do
    collection do
      post 'update_issue_done_ratio'
    end
  end
  resources :custom_fields, :except => :show
  resources :roles, :except => :show do
    collection do
      match 'permissions', :via => [:get, :post]
    end
  end
  resources :enumerations, :except => :show

  get 'projects/:id/search', :controller => 'search', :action => 'index'
  get 'search', :controller => 'search', :action => 'index'

  match 'mail_handler', :controller => 'mail_handler', :action => 'index', :via => :post

  match 'admin', :controller => 'admin', :action => 'index', :via => :get
  match 'admin/projects', :controller => 'admin', :action => 'projects', :via => :get
  match 'admin/plugins', :controller => 'admin', :action => 'plugins', :via => :get
  match 'admin/info', :controller => 'admin', :action => 'info', :via => :get
  match 'admin/test_email', :controller => 'admin', :action => 'test_email', :via => :get
  match 'admin/default_configuration', :controller => 'admin', :action => 'default_configuration', :via => :post

  resources :auth_sources do
    member do
      get 'test_connection'
    end
  end

  match 'workflows', :controller => 'workflows', :action => 'index', :via => :get
  match 'workflows/edit', :controller => 'workflows', :action => 'edit', :via => [:get, :post]
  match 'workflows/permissions', :controller => 'workflows', :action => 'permissions', :via => [:get, :post]
  match 'workflows/copy', :controller => 'workflows', :action => 'copy', :via => [:get, :post]
  match 'settings', :controller => 'settings', :action => 'index', :via => :get
  match 'settings/edit', :controller => 'settings', :action => 'edit', :via => [:get, :post]
  match 'settings/plugin/:id', :controller => 'settings', :action => 'plugin', :via => [:get, :post]

  match 'sys/projects', :to => 'sys#projects', :via => :get
  match 'sys/projects/:id/repository', :to => 'sys#create_project_repository', :via => :post
  match 'sys/fetch_changesets', :to => 'sys#fetch_changesets', :via => :get

  match 'uploads', :to => 'attachments#upload', :via => :post

  get 'robots.txt', :to => 'welcome#robots'

  Dir.glob File.expand_path("plugins/*", Rails.root) do |plugin_dir|
    file = File.join(plugin_dir, "config/routes.rb")
    if File.exists?(file)
      begin
        instance_eval File.read(file)
      rescue Exception => e
        puts "An error occurred while loading the routes definition of #{File.basename(plugin_dir)} plugin (#{file}): #{e.message}."
        exit 1
      end
    end
  end
end
