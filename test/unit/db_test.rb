require File.dirname(__FILE__) + '/../test_helper'

module Ohdb
	class DbTest < Ohdb::Test

		def test_connect_and_migrate
			with_temp_db do |db|
				assert FileTest.exist?(db.filename)
			end
		end

	end
end
