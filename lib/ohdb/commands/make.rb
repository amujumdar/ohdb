module Ohdb::Commands
	class Make < Base

		def run
			create_db

			if scm.head_token != CommitTask.most_recent_token
				puts "Adding commits to database..."
				count = 0
				commit_task = CommitTask.new.run(scm) do |commit|
					puts "Adding commit #{commit.token}" if @options.verbose
					count += 1
				end
				if commit_task.status == "OK"
					puts "Successfully added #{count} new commit(s)." unless options.quiet
				else
					STDERR.puts "#{commit_task.status}: #{commit_task.message}"
					exit 1
				end
			end

			if scm.head_token == LocDeltaTask.most_recent_token
				puts "Already up-to-date." unless @options.quiet
			else
				puts "Counting commits..."
				count = 0
				loc_delta_task = LocDeltaTask.new.run(scm) do |commit|
					puts "Counting commit #{commit.token}" if @options.verbose
					count += 1
				end
				if loc_delta_task.status == "OK"
					puts "Successfully counted #{count} new commit(s)." unless options.quiet
				else
					STDERR.puts "#{loc_delta_task.status}: #{loc_delta_task.message}"
					exit 1
				end
			end
		end

	end
end
