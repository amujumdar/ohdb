module Ohdb
	class Import < ActiveRecord::Base
		belongs_to :head, :class_name => "Commit"

		def run(scm)
			self.update_attributes(:head => Commit.last)
			scm.commits(head && head.token).each do |scm_commit|
				c = Commit.from_scm(scm_commit)
				c.save! unless Commit.find_by_token(scm_commit.token)
				self.update_attributes(:status => "RUNNING", :message => nil, :head => c)
			end
			self.update_attributes(:status => "OK", :message => nil)
			self
		end
	end
end
