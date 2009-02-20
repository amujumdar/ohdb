class CreateCommits < Ohdb::Migration  
	def self.up
		create_table :commits do |t|
			t.column :token, :string, :null => false
		end
	end

	def self.down
		drop_table :commits
	end
end
