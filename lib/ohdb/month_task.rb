module Ohdb
	class MonthTask < Task

		include TaskClassMethods

		def start_message
			"Finding the last commit of each month..."
		end

		def do_work(scm=nil)
			Month.ensure_months

			return unless Commit.count > 0

			start_date = (MonthTask.most_recent_head || Commit.first).date

			Month.months_between(start_date, Time.now.utc).each do |mm|
				month = Month.find_by_date(mm)
				month.update_attribute(:commit, month.find_last_commit)
				yield month.commit
			end
		end

	end
end

