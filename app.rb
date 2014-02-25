require 'sinatra'
require 'roar/representer/json/hal'

#
# Resoures & Representations (Media Types)
#

# API root resource 
class APIRoot
end

# API root resource HAL representation
module APIRootHALRepresentation
  include Roar::Representer::JSON::HAL
  link :self do 
    "/"
  end

  link :folders do
    "/folders"
  end
end

# Folder resource
class Folder
  attr_accessor :id
  attr_accessor :name
  attr_accessor :description
  attr_accessor :parent
  attr_accessor :meta

  def initialize (id = "", name = "", description = "")
    @id = id
    @name = name
    @description = description
    @parent = ""
    @meta = ""
  end

  def patch(folder)
    @name = folder.name unless folder.name.nil?
    @description = folder.description unless folder.description.nil?
    @parent = folder.parent unless folder.parent.nil?
    @meta = folder.meta unless folder.meta.nil?
  end
end

# Folder resource HAL representation
module FolderHALRepresentation
  include Roar::Representer::JSON::HAL

  property :id
  property :name
  property :description
  property :parent
  property :meta

  link :self do 
    "/folders/#{id}"
  end

  link :edit do 
    "/folders/#{id}"
  end  
end

# Folder resource JSON representation
module FolderJSONRepresentation
  include Roar::Representer::JSON

  property :id
  property :name
  property :description
  property :parent
  property :meta
end

# Folders resource
class Folders
  attr_accessor :folders

  DUMMY_DATA_COUNT = 3

  def initialize
    @folders = Array.new
    DUMMY_DATA_COUNT.times do |i|
      folder = Folder.new(i, "Folder ##{i}", "Lorem Ipsum #{i}")
      folder.extend(FolderHALRepresentation)
      @folders << folder
    end
  end

  def folder_count
    @folders.length
  end

  def folder_with_id(id)
    return nil unless id >= 0
    folder = @folders.detect { |folder| folder.id == id }
  end
end

# Folders resource HAL representation
module FoldersHALRepresentation
  include Roar::Representer::JSON::HAL

  property :folder_count

  link :self do 
    "/folders"
  end

  link :create do 
    "/folders"
  end

  collection :folders, extend: FolderHALRepresentation, class: Folder, embedded: true do
    property :id
    property :name
    property :description
  end  
end

#
# Data source (DB)
#

api_root = APIRoot.new
api_root.extend(APIRootHALRepresentation)

folders_collection = Folders.new
folders_collection.extend(FoldersHALRepresentation)

#
# API Routing
#

def hal_response(object, status_code = 200)
  headers "Content-Type" => "application/hal+json"
  status status_code
  body object.to_json
end

get '/' do
  hal_response(api_root)
end

get '/folders' do
  hal_response(folders_collection)
end

post '/folders' do
  request.body.rewind
  folder = Folder.new
  folder.extend(FolderJSONRepresentation)
  folder.from_json(request.body.read)
  folder.id = folders_collection.folders[-1].id + 1
  folder.extend(FolderHALRepresentation)
  folders_collection.folders << folder
  
  hal_response(folder, 201)
end

get '/folders/:id' do
  folder = folders_collection.folder_with_id(params[:id].to_i)
  return 404 unless folder

  hal_response(folder)
end

patch '/folders/:id' do
  folder = folders_collection.folder_with_id(params[:id].to_i)
  return 404 unless folder

  request.body.rewind
  patch_folder = Folder.new
  patch_folder.extend(FolderJSONRepresentation)
  patch_folder.from_json(request.body.read)

  folder.patch(patch_folder)  
  hal_response(folder)
end

delete '/folders/:id' do
  folder = folders_collection.folder_with_id(params[:id].to_i)
  return 404 unless folder

  folders_collection.folders.delete(folder)
  204
end
