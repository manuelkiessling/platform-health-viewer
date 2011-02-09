require 'couchrest/model'
CouchServer = CouchRest::Server.new # defaults to localhost:5984
CouchServer.default_database = "platformhealthviewer-#{Rails.env}"
