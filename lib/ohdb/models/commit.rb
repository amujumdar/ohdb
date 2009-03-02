module Ohdb
	class Commit < ActiveRecord::Base
		acts_as_list
		has_many :loc_deltas
		has_many :locs
		has_many :licenses
		has_many :platforms

		# Given an Scm::Commit, build a new Ohdb::Commit object
		def self.from_scm(scm_commit)
			new.copy_from_scm(scm_commit)
		end

		def copy_from_scm(scm_commit)
			self.token = scm_commit.token
			self.name = scm_commit.author_name || scm_commit.committer_name
			self.date = scm_commit.author_date || scm_commit.committer_date
			self.message_head = Commit.first_line(scm_commit.message)
			self
		end

		def self.first_line(s)
			s.split("\n").first[0,80] if s && s.split("\n").first
		end
	end
end
