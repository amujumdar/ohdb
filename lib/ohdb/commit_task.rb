module Ohdb
	class CommitTask < Task

		include TaskClassMethods

		def start_message
			"Adding commits to database..."
		end

		def do_work(scm)
			scm.each_commit(self.head && self.head.token) do |scm_commit|
				c = Commit.find_by_token(scm_commit.token) || Commit.new
				c.copy_from_scm(scm_commit)
				c.save!
				yield c
			end
		end

	end
end
