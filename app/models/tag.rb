class Tag < CouchRest::Model::Base
  use_database CouchServer.default_database
  property :name
  property :tags, [String]
  property :event_sources, [String]
  property :event_names, [String]

  view_by :name

  def save
    # TODO: This should be done within CouchDB
    if (!tags.empty?) then
      tags.each do |tag|
        ts = Tag.by_name(:key => tag)
        if (ts.empty?) then
          raise Exception.new("No tag by the name '" + tag + "', can't add to metatag")
        end
      end
    end
    super
  end

  def resolved_event_sources
    if (!self.tags.empty?) then
      event_sources = []
      self.tags.each do |subtag|
        event_sources = event_sources | Tag.sources_for_tagname(subtag)
      end
      return event_sources
    end
    self.event_sources
  end

  def resolved_event_names
    if (!self.tags.empty?) then
      event_names = []
      self.tags.each do |subtag|
        event_names = event_names | Tag.names_for_tagname(subtag)
      end
      return event_names
    end
    self.event_names
  end

  def self.sources_for_tagname(tagname)
    tags = Tag.by_name(:key => tagname)
    tag = Tag.find(tags[0]["_id"])
    tag.resolved_event_sources
  end

  def self.names_for_tagname(tagname)
    tags = Tag.by_name(:key => tagname)
    tag = Tag.find(tags[0]["_id"])
    tag.resolved_event_names
  end

end
