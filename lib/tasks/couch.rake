namespace :couch do
  task:setup do
    server = CouchRest::Server.new
    server.create_db("platformhealthviewer-production")
    server.create_db("platformhealthviewer-test")
    server.create_db("platformhealthviewer-development")
  end
end
