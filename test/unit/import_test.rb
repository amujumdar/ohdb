require File.dirname(__FILE__) + '/../test_helper'

module Ohdb
	class CommitTest < Ohdb::Test

		def test_import
			with_temp_db do

				#
				# Empty case. Nothing to do, should succeed.
				#
				scm = MockScm.new
				import = Import.new.run(scm)
				assert_equal "OK", import.status
				assert_equal nil, import.head
				assert_equal nil, import.message
				assert import.updated_at >= import.created_at
				assert_equal [nil], scm.commit_requests

				#
				# A single new commit. Insert the commit and update the head pointer.
				#
				scm = MockScm.new(:commits => [Scm::Commit.new(:token => 1)])
				import = Import.new.run(scm)
				assert_equal "OK", import.status
				assert_equal Commit.find_by_token(1), import.head
				assert_equal [nil], scm.commit_requests

				#
				# Incremental import.
				# Two commits, including one we've already seen. Should not result in a duplicate.
				#
				scm = MockScm.new(:commits => [Scm::Commit.new(:token => 1), Scm::Commit.new(:token => 2)])
				import = Import.new.run(scm)
				assert_equal "OK", import.status
				assert_equal Commit.find_by_token(2), import.head
				assert_equal 2, Commit.count
				# The importer should have requested only commits following the known head.
				assert_equal ["1"], scm.commit_requests

				#
				# Incremental import.
				# Multiple commits, but we've already seen all of them.
				#
				scm = MockScm.new(:commits => [Scm::Commit.new(:token => 1), Scm::Commit.new(:token => 2)])
				import = Import.new.run(scm)
				assert_equal "OK", import.status
				assert_equal Commit.find_by_token(2), import.head
				assert_equal 2, Commit.count
				# The importer should have requested only commits following the known head.
				assert_equal ["2"], scm.commit_requests
			end
		end

	end
end
