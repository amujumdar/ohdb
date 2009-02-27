module Ohdb::Commands
	class Status < Base
		def run
			connect_db

			total_commits = CommitTask.most_recent_position.to_i + scm.commit_count(CommitTask.most_recent_token)

			[CommitTask, LocDeltaTask, MonthTask, LocTask].each do |type|
				label = type.to_s.gsub("Ohdb::",'').gsub("Task","") + "s"
				puts "#{label.ljust(12)} head=#{(type.most_recent_token || 'NULL  ').rjust(6)} #{type.most_recent_position.to_i.to_s.rjust(6)} commits (#{how_far_behind(total_commits, type)}) #{type.most_recent ? type.most_recent.status : 'TODO'} #{type.most_recent ? type.most_recent.message.to_s : ''}"
			end
		end

		def how_far_behind(total_commits, type)
			if type.most_recent_position == total_commits
				"up-to-date"
			else
				"#{total_commits - type.most_recent_position.to_i} behind"
			end
		end

	end
end
