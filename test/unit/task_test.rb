require File.dirname(__FILE__) + '/../test_helper'

module Ohdb

	class MockTask < Task
		def do_work(scm)
			scm.commits.each { |c| yield Commit.find_by_token(c.token) }
		end
	end

	class MockTaskFail < Task
		def do_work(scm)
			raise RuntimeError.new("Oops!")
		end
	end

	class TaskTest < Ohdb::Test

		def test_run_ok
			with_temp_db do
				t = MockTask.new
				t.run(MockScm.new) do |t|
					assert_equal 'RUNNING', t.status
				end
				assert_equal 'OK', t.status
			end
		end

		def test_run_failed
			with_temp_db do
				t = MockTaskFail.new
				assert_raises(RuntimeError) do
					t.run(MockScm.new) do |t|
						assert_equal 'RUNNING', t.status
						raise RuntimeError.new("Oops!")
					end
				end
				assert_equal 'FAILED', t.status
				assert_equal 'Oops!', t.message
			end
		end

		def test_most_recent
			with_temp_db do
				assert !MockTask.most_recent
				assert !MockTask.most_recent_head
				assert !MockTask.most_recent_token

				c = Commit.create!(:token => "test")
				m = MockTask.new

				m.run(MockScm.new(:commits => [Scm::Commit.new(:token => "test")]))

				assert_equal m, MockTask.most_recent
				assert_equal c, MockTask.most_recent_head
				assert_equal "test", MockTask.most_recent_token
			end
		end

	end
end
