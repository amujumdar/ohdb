module Ohdb
	class Month < ActiveRecord::Base
		belongs_to :commit

		MIN_DATE=Time.gm(1980,1,1) unless defined?(MIN_DATE)

		# Ensures that there is a record for every month from MIN_MONTH up to the current month.
		def self.ensure_months(finish=Time.now.utc)
			start = (Month.last ? Month.last.date : MIN_DATE)

			months_between(start, finish).each do |m|
				Month.find_or_create_by_date(m)
			end
		end

		# Returns an array of the start of every month from start to finish, inclusive
		def self.months_between(start, finish)
			start_ord = start.utc.year * 12 + start.utc.month - 1
			finish_ord = finish.utc.year * 12 + finish.utc.month - 1

			(start_ord..finish_ord).collect { |o| Time.gm(o/12, o%12+1, 1)}
		end

		# Locate the last known commit within the calendar month
		def find_last_commit
			Commit.find(:last, :conditions => ["date(commits.date, 'start of month') <= date(?, 'start of month')", self.date])
		end
	end
end
