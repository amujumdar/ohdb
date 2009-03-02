module Ohdb
	class Platform < ActiveRecord::Base
		belongs_to :commit
	end
end
