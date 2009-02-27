module Ohdb
	class LocTask < Task

		include TaskClassMethods

		def start_message
			"Counting total lines of code in each month..."
		end

		def do_work(scm)
			start_date = (LocTask.most_recent_head || Commit.first).date
			Month.months_between(start_date, Time.now.utc).each do |mm|
				month = Month.find_by_date(mm)
				yield month.commit
			end
		end

	end
end

