require File.dirname(__FILE__) + '/../test_helper'

module Ohdb
	class MonthTaskTest < Ohdb::Test

		def test_month_task_empty
			with_temp_db do
				# No commits in database.
				# Should get a table of every month since MIN_MONTH, with all commit_ids NULL.
				assert_task_ok(month_task = MonthTask.new.run)
				assert_equal nil, month_task.head

				assert_equal Month::MIN_DATE, Month.first.date
				assert_equal nil, Month.first.commit
				assert_equal Time.gm(Time.now.utc.year, Time.now.utc.month,1), Month.last.date
				assert_equal nil, Month.last.commit

				# Add a single commit and run again.
				# Every month after this should show this commit.
				c_jan = Commit.create!(:token => "jan", :date => Time.gm(2008,1,1))
				assert_task_ok(month_task.run)
				assert_equal c_jan, month_task.head

				assert_equal nil, Month.find_by_date(Time.gm(2007,12,1)).commit
				assert_equal c_jan, Month.find_by_date(Time.gm(2008,1,1)).commit
				assert_equal c_jan, Month.find_by_date(Time.gm(2008,7,1)).commit

				# Add a commit in February
				c_feb1 = Commit.create!(:token => "feb1", :date => Time.gm(2008,2,1))
				assert_task_ok(month_task.run)
				assert_equal c_feb1, month_task.head

				assert_equal nil, Month.find_by_date(Time.gm(2007,12,1)).commit
				assert_equal c_jan, Month.find_by_date(Time.gm(2008,1,1)).commit
				assert_equal c_feb1, Month.find_by_date(Time.gm(2008,2,1)).commit
				assert_equal c_feb1, Month.find_by_date(Time.gm(2008,7,1)).commit

				# Add a second commit in Februrary
				c_feb2 = Commit.create!(:token => "feb2", :date => Time.gm(2008,2,2))
				assert_task_ok(month_task.run)
				assert_equal c_feb2, month_task.head

				assert_equal nil, Month.find_by_date(Time.gm(2007,12,1)).commit
				assert_equal c_jan, Month.find_by_date(Time.gm(2008,1,1)).commit
				assert_equal c_feb2, Month.find_by_date(Time.gm(2008,2,1)).commit
				assert_equal c_feb2, Month.find_by_date(Time.gm(2008,7,1)).commit
			end
		end

	end
end
