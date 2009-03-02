module Ohdb
	class MockScm
		attr_accessor :commit_requests
		attr_accessor :files

		def initialize(opts={})
			@commits = opts[:commits] || []
			@files = opts[:files] || {}
			@commit_requests = [] # Tracks calls to the commits() method for testing
		end

		def commit_tokens(since=nil)
			tokens = []
			each_commit(since) { |c| tokens << c.token }
			tokens
		end

		def commits(since=nil)
			commits = []
			each_commit(since) { |c| commits << c }
			commits
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

		def export(dir, token='ignored')
			@files.keys.each do |key|
				File.open(File.join(dir,key), 'w') { |f| f.write(@files[key]) }
			end
		end
	end
end
