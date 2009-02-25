module Ohdb
	class Task < ActiveRecord::Base
		belongs_to :head, :class_name => "Commit", :foreign_key => "head_commit_id"

		include TaskClassMethods

		def run(scm)
			begin
				self.update_attributes(:status => "RUNNING", :message => nil, :head => self.class.most_recent_head)
				do_work(scm) { |c| yield c if block_given? }
				self.update_attributes(:status => "OK")
				self
			rescue
				self.update_attributes(:status => "FAILED", :message => $!.message)
				raise
			end
		end

	end
end
