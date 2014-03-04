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
  
  patch_data = Folder.new
  patch_data.extend(FolderJSONRepresentation)
  patch_data.from_json(request.body.read)
  folder.patch(patch_data)

  hal_response(folder)
end

delete '/folders/:id' do
  folder = folders_collection.folder_with_id(params[:id].to_i)
  return 404 unless folder

  folders_collection.folders.delete(folder)
  204
end

# Set Sinatra HAL response
#   Serialize a resource to its HAL+JSON representation &
#   set appropriate Content-Type.
#
# @param object [Object] object to serialize in response body
# @param status_code [Integer] status code of the response
def hal_response(object, status_code = 200)
  headers 'Content-Type' => 'application/hal+json'
  status status_code
  body object.to_json
end
