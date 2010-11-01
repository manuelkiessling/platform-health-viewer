class Tag < CouchRest::Model::Base
  use_database CouchServer.default_database
  property :name
  property :tags, [String]
  property :event_sources, [String]
  property :event_names, [String]

  view_by :name

  def self.sources_for_tagname(tagname)
    tags = Tag.by_name(:name => tagname)
    tag = Tag.find(tags[0]["_id"])
    tag.event_sources
  end
end
