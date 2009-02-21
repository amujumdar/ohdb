require File.dirname(__FILE__) + '/../test_helper'

module Ohdb
	class DbTest < Ohdb::Test

		def test_basic_db_sanity
			with_temp_db do
				assert Commit.table_exists?
			end
		end

	end
end
