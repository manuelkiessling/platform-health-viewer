class Tag < CouchRest::Model::Base
  use_database CouchServer.default_database
  property :name
  property :tags, [String]
  property :event_sources, [String]
  property :event_names, [String]

  view_by :name
end
