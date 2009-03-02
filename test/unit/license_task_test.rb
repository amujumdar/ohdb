require File.dirname(__FILE__) + '/../test_helper'

module Ohdb
	class LicenseTaskTest < Ohdb::Test

		def test_license_task_empty
			with_temp_db do
				# No commits in database => no licenses
				assert_task_ok(license_task = LicenseTask.new.run)
				assert_equal nil, license_task.head
				assert_equal 0, License.count
			end
		end

		def test_license_task_easy
			scm = MockScm.new(:files => {'helloworld.rb' => '# Licensed under GPL Version 3 or later'})
			c = Commit.create(:token => 'test', :date => Time.now.utc)
			MonthTask.new.run
			assert_task_ok(license_task = LicenseTask.new.run(scm))
			assert_equal 1, c.reload.licenses.count
			assert_equal 'helloworld.rb', c.reload.licenses.first.path
			assert_equal 'gpl3_or_later', c.reload.licenses.first.name
		end

	end
end
