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
environment of choice, like Rails or PHP, very likely allows you to make HTTP
calls in a straight-forward manner.


## Troubleshooting

If you receive a "Errno::ECONNREFUSED" error message when opening PHV in your
browser, then this is because CouchDB is not running or can't be connected.
