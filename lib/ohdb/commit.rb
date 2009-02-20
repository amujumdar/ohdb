module Ohdb
	class Commit < ActiveRecord::Base
		acts_as_list

		# Given an Scm::Commit, build a new Ohdb::Commit object
		def self.from_scm(scm_commit)
			self.new(:token => scm_commit.token,
							 :name => scm_commit.author_name || scm_commit.committer_name,
							 :date => scm_commit.author_date || scm_commit.committer_date,
							 :message_head => first_line(scm_commit.message))
		end

		def self.first_line(s)
			s.split("\n").first[0,80] if s && s.split("\n").first
		end
	end
end
