require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'active_record'
require 'pry'

# Rails will do all this for you automagically.
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'database.sqlite3'
)

# Optional bonus
ActiveRecord::Base.logger = Logger.new(STDERR)

# Models
class Animal < ActiveRecord::Base
  belongs_to :group, :optional => true # Since Rails 5
end

class Group < ActiveRecord::Base
  has_many :animals
end

get '/' do
  erb :home
end

# INDEX - Show all animals
get '/animals' do
  @animals = Animal.all
  erb :animals_index
end

# INDEX - Show all groups
get '/groups' do
  @groups = Group.all
  erb :groups_index
end

# NEW GROUP
get '/groups/new' do
  erb :groups_new
end

# CREATE GROUP
post '/groups' do
  group = Group.new
  group.name = params[:name]
  group.save
  redirect to ("/groups/#{ group.id }")
end

# SHOW GROUP
get '/groups/:id' do
  @group = Group.find params[:id]
  erb :groups_show
end

# EDIT GROUP
get '/groups/:id/edit' do
  @group = Group.find params[:id]
  erb :groups_edit
end

# UPDATE GROUP
post '/groups/:id' do
  group = Group.find params[:id]
  group.name = params[:name]
  group.save
  redirect to("/groups/#{ group.id }")
end

# DELETE GROUP
get '/groups/:id/delete' do
  group = Group.find params[:id]
  group.destroy
  redirect to("/groups")
end

# binding.pry
