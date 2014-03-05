require 'roar/representer/json/hal'

# TODO API Resoures & Representations (Media Types)

# HTTP Content Type Header field & value representing 
#   HAL+JSON media type 
#
HAL_CONTENT_TYPE_HEADER = { 
  'Content-Type' => 'application/hal+json' 
}

# API root resource
#
class APIRoot
end

# API root resource HAL representation
#
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
#
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
#
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
#
module FolderJSONRepresentation
  include Roar::Representer::JSON

  property :id
  property :name
  property :description
  property :parent
  property :meta
end

# Folders collection resource
#
class Folders
  attr_accessor :folders
  
  def initialize(dummy_data_count = 0)
    @folders = Array.new
    dummy_data_count.times do |i|
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

# Folders collection resource HAL representation
#
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
