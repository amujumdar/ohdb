module Ohdb::Commands
	class Make < Base

		def run
			create_db

			task_classes = [CommitTask, LocDeltaTask, MonthTask, LocTask]

			if task_classes.last.most_recent_token == scm.head_token
				puts "Already up-to-date."
			else
				task_classes.each do |task_class|
					if scm.head_token != task_class.most_recent_token
						task = task_class.new
						puts task.start_message
						task.run(scm) do |commit|
							puts commit.token if @options.verbose
						end
						if task.status != "OK"
							STDERR.puts "#{task.status}: #{task.message}"
							exit 1
						end
					end
				end
			end

		end

	end
end
