module Ohdb
	class MonthlyTask < Task

		include TaskClassMethods

		def start_message
			"Analyzing each month..."
		end

		def do_work(scm)
			head = self.class.most_recent_head || Commit.first
			if head
				Month.months_between(head.date, Time.now.utc).each do |mm|
					month = Month.find_by_date(mm)
					do_commit(scm, month.commit) unless month.commit == self.head
					yield month.commit
				end
			end
		end

	end
end

