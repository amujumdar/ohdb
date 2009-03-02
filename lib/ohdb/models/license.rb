module Ohdb
	class License < ActiveRecord::Base
		belongs_to :commit
	end
end
