var util   = require("util"),
    sqlite = require("/Users/manuel/.node_libraries/sqlite"),
    http   = require("http"),
    url    = require("url");

var db = new sqlite.Database();

db.open("../db/development.sqlite3", function (error) {
  if (error) {
      console.log("Failed to open DB file");
      throw error;
  }

  http.createServer(function(request, response) {
    console.log("Received request: " + request.url);
    var q = url.parse(request.url, true);
    if (q.query) {
      if (q.query.source && q.query.name && q.query.value) {
        console.log("Source: " + q.query.source);
        console.log("Name: " + q.query.name);
        console.log("Value: " + q.query.value);

        db.execute
        ( "INSERT INTO queue_events (source, name, value, created_at) VALUES (?, ?, ?, strftime('%s','now'))",
          [q.query.source, q.query.name, q.query.value],
          function (error, rows) {
            if (error) throw error;
            console.log("Event added to queue.");
            response.writeHead(200, {"Content-Type": "text/html"});
            response.write("Event added to queue.");
            response.end();
          }
        );
      }
    } else {
      console.log("Ignoring request: " + request.url);
    }
  }).listen(8888);
});

console.log("Started...");
