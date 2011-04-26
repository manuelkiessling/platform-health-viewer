# PlatformHealthViewer

## About

PlatformHealthViewer allows you to build dashboard screens that visualize key
performance data from any kind of internet service. If, for example, you would
like to display the number of logins on your website as a line graph, all you
need to do is to feed this data into the system using simple HTTP requests, and
place a graph that represents this data on the dashboard with one simple click.

There is a 10 minute long introduction video (in english, with subtitles) over
at Youtube: http://www.youtube.com/watch?v=HI6SRqz_3D0

The main design principle behind PHV is to make feeding data into the system
and representing this data as graphs as straight forward as possible.

To achieve this, PHV allows you to feed numeric data from any kind of source
into its server, without the need for any upfront configuration.
In order to make data visualization as simple as possible, PHV offers an
interactive web interface which allows you to freely place and resize graphs.


## Installation

### Debian GNU/Linux 6.0 Squeeze

Assuming that we have a base system with at least the "Standard system
utilities" collection installed, we need the following extra software to
run PHV:

 * Git
 * Ruby 1.8
 * RubyGems
 * Bundler
 * Rails 3.0
 * MySQL 5.1
 * CouchDB
 * And of course PHV itself

Please note that as of now, PHV is not tested with Ruby 1.9 and might not work
with this version of Ruby. Likewise, Ruby on Rails versions earlier than 3.0.0
are not supported.

All commands need to be issued as root unless otherwise stated.

First we need to install a bunch of Debian packages using apt-get:

	apt-get install git-core ruby1.8 rubygems1.8 couchdb mysql-server-5.1 \
	                libmysqlclient-dev

When installing the MySQL server, the system will ask you (multiple times) to
choose a root password. Provide a password of your choice and write it down for
later usage. If you know the implications, you can of course also choose to use
an empty password.

We will use _RubyGems_ to install additional Ruby libraries (gems). Those are
installed to /var/lib/gems/1.8. Because this location is not on our systems's
path, and typing "/var/lib/gems/1.8/bin/rails" every time is tedious, we are
going to add this location to our path:

	echo "export PATH=$PATH:/var/lib/gems/1.8/bin" >> /etc/profile
	source /etc/profile

Now we need to install additional Ruby libraries using RubyGems:

	gem install bundler
	gem install rails

Great, now we have installed and configured all software packages that are
neccessary to start the PHV installation itself.

The following steps describe how to get PHV running on your system. The
installation location for PHV is up to you, for this tutorial I have choosen
to install it to _/opt/PlatformHealthViewer_.

First, we need to get the latest stable version of the PHV source code:

	cd /opt
	git clone git://github.com/ManuelKiessling/PlatformHealthViewer.git

Next, we have to make sure that all additional gems that PHV needs will be
installed:

	cd /opt/PlatformHealthViewer
	bundle install

If you chose to protect your MySQL installation with a password, you need to
configure this password in the database config file of PHV, using an editor of
your choice (e.g. vi):

	vi config/database.yml
	
You will need to provide the password in lines 7, 18 and 29. When this is done,
the MySQL database structures can be installed:

	rake db:setup
	
Not to forget the CouchDB databases:

	rake couch:setup

If these tasks finish without errors, we can verify that PHV is working as
expected by running its unit tests:

	rake test:units

Everything went ok if the last line of the test output reads

	28 tests, 28 assertions, 0 failures, 0 errors

Now is the time to start the rails application server:

	rails s
	
This allows you to open the PHV application in your browser:

http://_YourServersAddress_:3000/

(If at this point you receive a "Errno::ECONNREFUSED" error message, then this
is because CouchDB is not running or can't be connected).

You will of course need to replace _YourServersAddress_ with the actual IP or
DNS name of the server you installed PHV on.

However, what you are going to see might probably be a bit disappointing,
because after all you are shown an empty dashboard. This is because there
hasn't been fed any data into PHV yet, which is why there a no graphs added
to the dashboard that could represent any data.

Read the next chapter to find out how to breath live into your PHV
installation.


## Feeding demo data into your PHV server

The easiest way to add data and visualizations to your PHV installation is to
run a utility script that will feed randomized demo data into the server and
add a graph to the dashboard representing this demo data.

While still in _/opt/PlatformHealthViewer_ (or whatever location you chose to
install PHV to), run

	rake demodata:create

This will take around 1 minute. Once finished, go back to your browser and
refresh the current page. You will now see a graph on the Dashboard page and
the demo events and tag on the Tageditor page.

If you no longer need the demo data, you can remove it completely by issueing

	rake demodata:remove


## Feeding real data into your PHV server

As mentioned above, the goal is to make feeding data into PHV as simple as
possible, while allowing the data to come from whatever source you have.
This is why I decided to use a simple, lightweight and very common protocol
for pushing events into the PHV database: HTTP.

This way, it's really simple to collect all the data you need. Issueing HTTP
requests can be done from any Unix command line, using _curl_. Your programming
environment of choice, like Java, Rails or PHP, very likely allows you to make
HTTP calls in a straight-forward manner.

As of now, only HTTP POST requests are supported. Still assuming that you have
PHV running at http://_YourServersAddress_:3000/, you will need to make an HTTP
POST request to

http://YourServersAddress:3000/queue_event

with the following POST parameters:

	event[source]
	event[name]
	event[value]

On the Linux command line, one way to easily create HTTP POST requests is by
using _curl_.

_curl_ is a versatile unix command line tool to create any kind of HTTP
request. It's available on all major platforms. On Debian GNU/Linux, you can
install it with

	apt-get install curl

A typical _curl_ command line with a valid PHV request would look like this:

	curl --data "event[value]=0.4&event[source]=myhost&event[name]=cpu_load" \
	            http://YourServersAddress:3000/queue_event

As noted in the introduction, you don't need to do any upfront configuration in
order to push new data into the system. As long as you can reach your PHV
system with HTTP, you can push into the system whatever you like (right, as of
now, there isn't any kind of authentication either).

Ok, let's try a real world example. If you followed the installation section
above, you will have PHV running on a Debian GNU/Linux 6.0 system. What about
collecting and visualizing this system's CPU load within PHV?

All we need is a way to make HTTP POST requests as explained above, and of
course we need to get the actual CPU load value. Let's use good old _uptime_
for this:

	root@debian:~# uptime
	 05:10:10 up  6:53,  4 users,  load average: 0.10, 0.04, 0.01

We want to grab the 1 minute average (0.10 in the above example), which we will
get using some cut magic:

	root@debian:~# uptime | cut -b 46-49
	0.10

Great, that will do for now. Let's build a working _curl_ command line:

	curl --data "event[value]=`uptime | \
	 cut -b 46-49`&event[source]=debian&event[name]=cpu_load" \
	 http://localhost:3000/queue_event

As you can see, I decided to name this event's source _debian_ - you can choose
a different name of course.

Ok, now we pushed one event into the PHV server, but if you reload
http://_YourServersAddress_:3000/ in your browser, you won't see any events
with a source name _debian_ in the _All event types_ box.

This is because new events that are pushed into PHV are only queued for further
processing to speed up event insertion. To make them available in the _Tag
editor_ (and to subsequentially visualize them on the dashboard), you need to
"convert" them to their final location in the database.

This is done using the following command:

	rake queue:convert

If afterwards you reload the Tag editor page in your browser, you will see the
_debian cpu_load_ entry in the _All event types_ box.

The _curl_ command line plus the rake task is all you need to make data
available within PHV. You are completely free to feed any value (as long as
it's a float) from any system into your PHV server, as long as you can provide
a command line that produces the intended event value, and as long as the
system you are pushing the events from is able to connect to your PHV server
via HTTP.

In practice you will probably want to push the event values of a system into
PHV continuously - you can use _watch_ or a cronjob for this purpose:

	watch -n 5 'curl --data "event[value]=`uptime | \
	 cut -b 46-49`&event[source]=debian&event[name]=cpu_load" \
	 http://localhost:3000/queue_event'

will feed the current CPU load into PHV every five seconds, while a crontab
like

	* * * * *	nobody	curl --data "event[value]=`uptime | cut -b 46-49`&event[source]=debian&event[name]=cpu_load" http://localhost:3000/queue_event

will feed that value every minute.


## Event Agents

As of now, PHV really is about providing an "event-type and event-source
agnostic" platform, which is why collecting event values and pushing them into
PHV is very much up to you - which gives you great flexibility, but might be
cumbersome.

This might or might not change with future versions, but after all, PHV will
always have to stick to common and simple agents (CPU load, free disk space,
web site load time etc.) when providing agents itself. It's the pain-free
process of adding and visualizing highly specific data (that only _your_
application/website generates and only _you_ need to have visualized) where
PHV tries to help.

However, a very basic set of common agents are already available in the

	script/agents/

folder. Feel free to have a look. To feed the different, for example, the
different CPU performance indicators of your Mac into a PHV server running at
_YourServersAddress:3000_, simply call

	bash script/agents/macosx/cpu_overview_percent.sh http://localhost:3000/ macbook

from your Mac's Terminal. There is a similar agent script for Linux systems.


## Contributing & Getting in touch

I would love to receive feedback, feature requests, bug reports, and of course
pull requests for PHV.

Add issues at https://github.com/ManuelKiessling/PlatformHealthViewer/issues or
fork on Github using
https://github.com/ManuelKiessling/PlatformHealthViewer/fork

You can reach me at manuel@kiessling.net, or follow me on Twitter
@manuelkiessling
