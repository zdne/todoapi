require 'sinatra'
require_relative 'domain_model'

# Data source (DB)
#
api_root = APIRoot.new
api_root.extend(APIRootHALRepresentation)

DUMMY_DATA_COUNT = 3 
folders_collection = Folders.new(DUMMY_DATA_COUNT)
folders_collection.extend(FoldersHALRepresentation)

# API Routing
#
get '/' do
  headers HAL_CONTENT_TYPE_HEADER
  api_root.to_json
end

get '/folders' do
  headers HAL_CONTENT_TYPE_HEADER
  folders_collection.to_json
end

post '/folders' do
  request.body.rewind
  
  folder = Folder.new
  folder.extend(FolderJSONRepresentation)
  folder.from_json(request.body.read)
  folder.id = folders_collection.folders[-1].id + 1
  folder.extend(FolderHALRepresentation)
  folders_collection.folders << folder
  
  headers HAL_CONTENT_TYPE_HEADER
  body folder.to_json
  201
end

get '/folders/:id' do
  folder = folders_collection.folder_with_id(params[:id].to_i)
  return 404 unless folder

  headers HAL_CONTENT_TYPE_HEADER
  folder.to_json
end

patch '/folders/:id' do
  folder = folders_collection.folder_with_id(params[:id].to_i)
  return 404 unless folder

  request.body.rewind
  
  patch_data = Folder.new
  patch_data.extend(FolderJSONRepresentation)
  patch_data.from_json(request.body.read)
  
  folder.patch(patch_data)

  headers HAL_CONTENT_TYPE_HEADER
  folder.to_json
end

delete '/folders/:id' do
  folder = folders_collection.folder_with_id(params[:id].to_i)
  return 404 unless folder

  folders_collection.folders.delete(folder)
  204
end
