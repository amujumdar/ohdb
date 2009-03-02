require 'test/unit'
require 'tempfile'

OHDB_ENV='test'

unless defined?(TEST_DIR)
	TEST_DIR = File.dirname(__FILE__)
end
require TEST_DIR + '/../lib/ohdb'

require File.join(TEST_DIR, 'mock_scm')

ActiveRecord::Base.logger = Logger.new(File.open(File.join(OHDB_ROOT, 'log/test.log'), 'a'))

module Ohdb
	class Test < Test::Unit::TestCase
		# For reasons unknown, the base class defines a default_test method to throw a failure.
		# We override it with a no-op to prevent this 'helpful' feature.
		def default_test
		end

		def with_temp_db
			Database.create(":memory:")
			yield
		end

		def assert_task_ok(t)
			assert_equal "OK", t.status
			assert_equal nil, t.message
			assert t.updated_at >= t.created_at
		end
	end
end
