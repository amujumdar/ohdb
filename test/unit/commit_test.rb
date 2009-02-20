require File.dirname(__FILE__) + '/../test_helper'

module Ohdb
	class DbTest < Ohdb::Test

		def test_basic_database_sanity
			with_temp_db do |db|
				assert_equal 0, Commit.count
			end
		end
	end
end
