require File.dirname(__FILE__) + '/../test_helper'

module Ohdb
	class CommitTest < Ohdb::Test

		def test_from_scm_commit
			with_temp_db do
				scm_commit = Scm::Commit.new(:token => 1,
																		 :author_name => 'robin',
																		 :author_date => Time.gm(2000, 1, 1),
																		 :message => "First line\nsecond line\n")

				db_commit = Ohdb::Commit.from_scm(scm_commit)
				db_commit.save!
				db_commit.reload

				assert_equal scm_commit.token.to_s, db_commit.token
				assert_equal scm_commit.author_name, db_commit.name
				assert_equal scm_commit.author_date, db_commit.date
				assert_equal "First line", db_commit.message_head
				assert_equal 1, db_commit.position
			end
		end

		def test_prefer_author_to_committer
			with_temp_db do
				db_commit = Ohdb::Commit.from_scm(Scm::Commit.new(:committer_name => 'committer', :author_name => 'author'))
				assert_equal db_commit.name, 'author'
				db_commit = Ohdb::Commit.from_scm(Scm::Commit.new(:committer_name => nil, :author_name => 'author'))
				assert_equal db_commit.name, 'author'
				db_commit = Ohdb::Commit.from_scm(Scm::Commit.new(:committer_name => 'committer', :author_name => nil))
				assert_equal db_commit.name, 'committer'

				author_date = Time.gm(2008,1,1)
				committer_date = Time.gm(2008,2,2)

				db_commit = Ohdb::Commit.from_scm(Scm::Commit.new(:committer_date => committer_date, :author_date => author_date))
				assert_equal db_commit.date, author_date
				db_commit = Ohdb::Commit.from_scm(Scm::Commit.new(:committer_date => nil, :author_date => author_date))
				assert_equal db_commit.date, author_date
				db_commit = Ohdb::Commit.from_scm(Scm::Commit.new(:committer_date => committer_date, :author_date => nil))
				assert_equal db_commit.date, committer_date
			end
		end
	end
end
