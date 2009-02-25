module Ohdb
	class CommitTask < Task

		include TaskClassMethods

		def do_work(scm)
			scm.each_commit(self.head && self.head.token) do |scm_commit|
				c = Commit.find_by_token(scm_commit.token) || Commit.new
				c.copy_from_scm(scm_commit)
				c.save!
				self.update_attributes(:head => c)
				yield c if block_given?
			end
		end

	end
end
