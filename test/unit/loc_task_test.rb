require File.dirname(__FILE__) + '/../test_helper'

module Ohdb
	class LocTaskTest < Ohdb::Test

		def test_loc_task_empty
			with_temp_db do
				# No commits in database => no locs
				assert_task_ok(loc_task = LocTask.new.run)
				assert_equal nil, loc_task.head
				assert_equal 0, Loc.count
			end
		end

		def test_loc_task_easy
			scm = MockScm.new(:files => {'helloworld.rb' => "#!/usr/bin/env ruby\n# A comment\n\n\n\nputs 'Hello, world!'\n"})
			c = Commit.create(:token => 'test', :date => Time.now.utc)
			MonthTask.new.run
			assert_task_ok(loc_task = LocTask.new.run(scm))
			assert_equal 1, c.reload.locs.count
			assert_equal 'ruby', c.reload.locs.first.language
			assert_equal 1, c.reload.locs.first.filecount
			assert_equal 1, c.reload.locs.first.code
			assert_equal 2, c.reload.locs.first.comments
			assert_equal 3, c.reload.locs.first.blanks
		end

	end
end

