module Ohdb
	class MockScm
		attr_accessor :commit_requests

		def initialize(opts={})
			@commits = opts[:commits] || []
			@commit_requests = [] # Tracks calls to the commits() method for testing
		end

		def each_commit(since=nil)
			@commit_requests << since

			current = if since
				i = @commits.collect{|c| c.token.to_s}.index(since)
				@commits[(i+1)..-1]
			else
				@commits
			end

			current.each do |c|
				yield c if block_given?
			end
		end
	end
end
