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
    console.log("Received request...");
    db.execute
    ( "INSERT INTO queue_events (source, name, value, created_at) VALUES (?, ?, ?, ?)",
      ['cron01', 'cpu_load', '1.99', '2010-11-01 10:06:01.465355'],
      function (error, rows) {
        if (error) throw error;
        console.log("Event added to queue.");
        response.writeHead(200, {"Content-Type": "text/html"});
        response.write("Event added to queue.");
        response.end();
      }
    );
  }).listen(8888);
});

console.log("Started...");
