class Tag < CouchRest::Model::Base
  use_database CouchServer.default_database
  property :name
  property :tags, [String]
  property :event_sources, [String]
  property :event_names, [String]

  view_by :name

  def save
    if (!tags.empty?) then
      tags.each do |tag|
        ts = Tag.by_name(:key => tag)
        if (ts.empty?) then
          raise Exception.new("No tag by that name, can't add to metatag")
        end
      end
    end
    super
  end

  def resolved_event_names
    Tag.names_for_tagname(name)
  end

  def resolved_event_sources
    Tag.sources_for_tagname(name)
  end

  def self.sources_for_tagname(tagname)
    tags = Tag.by_name(:key => tagname)
    tag = Tag.find(tags[0]["_id"])
    if (!tag.tags.empty?) then
      event_sources = []
      tag.tags.each do |subtag|
        event_sources = event_sources | self.sources_for_tagname(subtag)
      end
      return event_sources
    end
    tag.event_sources
  end

  def self.names_for_tagname(tagname)
    tags = Tag.by_name(:key => tagname)
    tag = Tag.find(tags[0]["_id"])
    if (!tag.tags.empty?) then
      event_names = []
      tag.tags.each do |subtag|
        event_names = event_names | self.names_for_tagname(subtag)
      end
      return event_names
    end
    tag.event_names
  end

end
