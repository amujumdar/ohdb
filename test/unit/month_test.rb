require File.dirname(__FILE__) + '/../test_helper'

module Ohdb
	class MonthTest < Ohdb::Test

		def test_ensure_months
			with_temp_db do
				assert_equal 0, Month.count
				last_date = Time.gm(1982,3,12,1,2,3)

				Month.ensure_months(last_date)

				# Check the bounds
				assert_equal Month::MIN_DATE, Month.first.date
				assert_equal Time.gm(1982, 3, 1), Month.last.date

				# Check an arbitrary item in the middle
				assert_equal Time.gm(1981, 8, 1), Month.find_by_date(Time.gm(1981, 8, 1)).date

				# Calling ensure_months again should not create new rows
				count = Month.count
				Month.ensure_months(last_date)
				assert_equal count, Month.count
			end
		end

		def test_months_between
			assert_equal [Time.gm(2008,1,1)], Month.months_between(Time.gm(2008,1,1), Time.gm(2008,1,1))
			assert_equal [Time.gm(2008,1,1)], Month.months_between(Time.gm(2008,1,1), Time.gm(2008,1,30))
			assert_equal [Time.gm(2008,1,1)], Month.months_between(Time.gm(2008,1,30), Time.gm(2008,1,1))
			assert_equal [Time.gm(2008,1,1), Time.gm(2008,2,1)], Month.months_between(Time.gm(2008,1,1), Time.gm(2008,2,1))
			assert_equal [Time.gm(2008,12,1), Time.gm(2009,1,1)], Month.months_between(Time.gm(2008,12,1), Time.gm(2009,1,1))

			long_list = Month.months_between(Time.gm(2000,10,1), Time.gm(2002,3,1))
			assert_equal 18, long_list.size
			assert_equal Time.gm(2000,10,1), long_list.first
			assert_equal Time.gm(2002,3,1), long_list.last
		end

		def test_find_commit
			with_temp_db do
				c_jan = Commit.create(:token => "jan", :date => Time.gm(2008,1,1))
				c_feb1 = Commit.create(:token => "feb1", :date => Time.gm(2008,2,1))
				c_feb2 = Commit.create(:token => "feb2", :date => Time.gm(2008,2,2))
				c_apr = Commit.create(:token => "apr", :date => Time.gm(2008,4,1))

				# In the months before the first commit, should be nil
				assert_equal nil, Month.new(:date => Time.gm(2007,12,1)).find_last_commit

				# In the month with only one commit, should return the commit
				assert_equal c_jan, Month.new(:date => Time.gm(2008,1,1)).find_last_commit

				# In the month with multiple commits, should return the last commit
				assert_equal c_feb2, Month.new(:date => Time.gm(2008,2,1)).find_last_commit
				assert_equal c_feb2, Month.new(:date => Time.gm(2008,2,28)).find_last_commit

				# In the month without a commit, should return last commit from prior month
				assert_equal c_feb2, Month.new(:date => Time.gm(2008,3,1)).find_last_commit

				# In all months following final commit, should return final commit
				assert_equal c_apr, Month.new(:date => Time.gm(2008,4,1)).find_last_commit
				assert_equal c_apr, Month.new(:date => Time.gm(2008,7,1)).find_last_commit
				assert_equal c_apr, Month.new(:date => Time.gm(2009,1,1)).find_last_commit
			end
		end

	end
end
