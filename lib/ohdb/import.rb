module Ohdb
	class Import < ActiveRecord::Base
		belongs_to :head, :class_name => "Commit", :foreign_key => "head_commit_id"

		def run(scm)
			begin
				self.update_attributes(:status => "RUNNING", :message => nil, :head => Commit.last)

				scm.each_commit(head && head.token) do |scm_commit|
					c = Commit.find_by_token(scm_commit.token) || Commit.new
					c.copy_from_scm(scm_commit)
					c.save!
					self.update_attributes(:head => c)
					yield c if block_given?
				end

				self.update_attributes(:status => "OK")
				self
			rescue
				self.update_attributes(:status => "FAILED", :message => $!.message)
				raise
			end
		end
	end
end
