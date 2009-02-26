module Ohdb
	module TaskClassMethods
		def self.included(base)
			base.extend(ClassMethods)
		end

		module ClassMethods
			def most_recent
				self.first(:first, :include => :head, :order => 'commits.position desc, updated_at desc')
			end

			def most_recent_head
				most_recent && most_recent.head
			end

			def most_recent_token
				most_recent_head && most_recent_head.token
			end

			def most_recent_position
				most_recent_head && most_recent_head.position
			end
		end
	end
end
