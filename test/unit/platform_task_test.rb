require File.dirname(__FILE__) + '/../test_helper'

module Ohdb
	class PlatformTaskTest < Ohdb::Test

		def test_platform_task_empty
			with_temp_db do
				# No commits in database => no platforms
				assert_task_ok(platform_task = PlatformTask.new.run)
				assert_equal nil, platform_task.head
				assert_equal 0, Platform.count
			end
		end

		def test_platform_task_easy
			scm = MockScm.new(:files => {'helloworld.rb' => 'puts "Hello, world!"'})
			c = Commit.create(:token => 'test', :date => Time.now.utc)
			MonthTask.new.run
			assert_task_ok(platform_task = PlatformTask.new.run(scm))
			assert_equal 1, c.reload.platforms.count
			assert_equal 'Ruby', c.reload.platforms.first.name
		end

	end
end
