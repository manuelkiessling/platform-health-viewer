# PlatformHealthViewer

## About

PlatformHealthViewer allows you to build dashboard screens that visualize key
performance data from any kind of internet service. If, for example, you would
like to display the number of logins on your website as a line graph, all you
need to do is to feed this data into the system using simple HTTP requests, and
place a graph that represents this data on the dashboard with one simple click.

The main design principle behind PHV is to make feeding data into the system
and representing this data as graphs as straight forward as possible.

To achieve this, PHV allows you to feed numeric data from any kind of source
into its server, without the need for any upfront configuration.
In order to make data visualization as simple as possible, PHV offers an
interactive web interface which allows you to freely place and resize graphs.

## Installation

### Debian GNU/Linux 6.0 Squeeze

Assuming that we have a base system with the "Standard system utilities"
collection installed, we need the following extra software to run PHV:

 * Git
 * Ruby 1.8
 * RubyGems
 * Bundler
 * Rails 3
 * MySQL 5.1
 * CouchDB
 * And of course PHV itself

All commands need to be issued as root unless otherwise stated.

First we need to install the following Debian packages:

	apt-get install git-core ruby1.8 rubygems1.8 couchdb mysql-server-5.1 libmysqlclient-dev

When installing the MySQL Server, the system will ask you (multiple times) to
choose a root password. Provide a password of your choice and write it down for
later usage.

We will use "gem" to install additional Ruby libraries (gems). Those are
installed to /var/lib/gems/1.8/bin. Because this location is not on our
systems's path, and typing "/var/lib/gems/1.8/bin/rails" every time is
tedious, we are going to add this location to our path:

	echo "export PATH=$PATH:/var/lib/gems/1.8/bin" >> /etc/profile
	source /etc/profile

Now we need to install additional Ruby libraries using RubyGems:

	gem install bundler
	gem install rails

Great, now we have installed and configured all software packages that are
neccessary to start the PHV installation itself.

The following steps describe how to get PHV running on your system. The
installation location for PHV is up to you, for this tutorial I have choosen
to install it to /opt/PlatformHealthViewer.

First, we need to get the latest version of the PHV source code:

	cd /opt
	git clone git://github.com/ManuelKiessling/PlatformHealthViewer.git

Next, we have to make sure that all additional gems that PHV need will be
installed:

	cd /opt/PlatformHealthViewer
	bundle install

If you choose to protect your MySQL installation with a password, you need to
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

Everything went ok if the last line of the test output is

	28 tests, 28 assertions, 0 failures, 0 errors


## Troubleshooting

If you receive a "Errno::ECONNREFUSED" error message when opening PHV in your
browser, then this is because CouchDB is not running or can't be connected.

## TODO
