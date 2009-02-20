module Ohdb
end

OHDB_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

require 'rubygems'
require 'ohcount'
require 'scm'
require 'sqlite3'
require 'activerecord'

require File.join(OHDB_ROOT, 'lib/ohdb/database')
require File.join(OHDB_ROOT, 'lib/ohdb/migration')
require File.join(OHDB_ROOT, 'lib/ohdb/commit')
