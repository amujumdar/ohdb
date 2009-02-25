module Ohdb
end

OHDB_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$: << OHDB_ROOT

require 'rubygems'

# The following Ohloh requires are a bit unusual to ease development.
# First we attempt to load the library as a gem.
# If that fails, we look for the lib in a directory parallel to the ohdb code tree.
begin
	require 'ohcount'
rescue LoadError
	require '../ohcount/lib/ohcount'
end

begin
	require 'scm'
rescue LoadError
	require '../scm/lib/scm'
end

require 'sqlite3'
require 'activerecord'

require 'vendor/plugins/acts_as_list/init'

require 'lib/ohdb/database'
require 'lib/ohdb/migration'
require 'lib/ohdb/commit'
require 'lib/ohdb/import'
