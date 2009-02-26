module Ohdb::Commands
	class Status < Base
		def run
			connect_db

			commits_in_db = Ohdb::Commit.count
			puts "Total commits in database:  #{commits_in_db.to_s.rjust(6,' ')}  (#{how_far_behind(CommitTask)})"

			counted_commits_in_db = Ohdb::Commit.count(:conditions => 'id in (select commit_id from loc_deltas)')
			puts "          Counted commits:  #{counted_commits_in_db.to_s.rjust(6,' ')}  (#{how_far_behind(LocDeltaTask)})"

			puts "Last successful update: #{LocDeltaTask.most_recent.updated_at.localtime}" if LocDeltaTask.most_recent
		end

		def how_far_behind(task_class)
			if task_class.most_recent_token
				if task_class.most_recent_token == scm.head_token
					"up-to-date"
				else
					"#{scm.commit_count(task_class.most_recent_token)} behind"
				end
			else
				"#{scm.commit_count} behind"
			end
		end

	end
end
