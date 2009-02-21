module Ohdb
	class Import < ActiveRecord::Base
		belongs_to :head, :class_name => "Commit", :foreign_key => "head_commit_id"

		def run(scm)
			self.update_attributes(:head => Commit.last)

			scm.each_commit(head && head.token) do |scm_commit|
				c = Commit.from_scm(scm_commit)
				c.save! unless Commit.find_by_token(scm_commit.token)
				self.update_attributes(:status => "RUNNING", :message => nil, :head => c)
				yield c if block_given?
			end

			self.update_attributes(:status => "OK", :message => nil)
			self.save!
			self
		end
	end
end
