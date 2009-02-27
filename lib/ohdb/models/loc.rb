module Ohdb
	class Loc < ActiveRecord::Base
		belongs_to :commit
	end
end
