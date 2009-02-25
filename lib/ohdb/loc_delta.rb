module Ohdb
	class LocDelta < ActiveRecord::Base
		belongs_to :commit
	end
end
