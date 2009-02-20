require 'test/unit'
require 'tempfile'

OHDB_ENV='test'

unless defined?(TEST_DIR)
	TEST_DIR = File.dirname(__FILE__)
end
require TEST_DIR + '/../lib/ohdb'

ActiveRecord::Base.logger = Logger.new(File.open(File.join(OHDB_ROOT, 'log/test.log'), 'a'))

module Ohdb
	class Test < Test::Unit::TestCase
		# For reasons unknown, the base class defines a default_test method to throw a failure.
		# We override it with a no-op to prevent this 'helpful' feature.
		def default_test
		end

		def with_temp_db
			db = Database.new(Tempfile.new('test').path)
			db.migrate
			yield db
		end
	end
end
