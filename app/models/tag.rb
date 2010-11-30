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
        t = Tag.find_by_name(tag)
        if (t.nil?) then
          raise Exception.new("No tag by the name '" + tag + "', can't add to metatag")
        end
      end
    end
    super
  end

  def resolved_event_sources
    event_sources = []
    if (!self.tags.empty?) then
      self.tags.each do |subtag|
        event_sources = event_sources | Tag.sources_for_tagname(subtag)
      end
    end
    self.event_sources | event_sources
  end

  def resolved_event_names
    event_names = []
    if (!self.tags.empty?) then
      self.tags.each do |subtag|
        event_names = event_names | Tag.names_for_tagname(subtag)
      end
    end
    self.event_names | event_names
  end

  def self.sources_for_tagname(tagname)
    tag = Tag.find_by_name(tagname)
    tag.resolved_event_sources
  end

  def self.names_for_tagname(tagname)
    tag = Tag.find_by_name(tagname)
    tag.resolved_event_names
  end

end
