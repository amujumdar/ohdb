class CreateCommits < Ohdb::Migration  
	def self.up
		create_table :commits do |t|
			t.column :token, :string, :null => false
			t.column :name, :string
			t.column :date, :datetime
			t.column :message_head, :string
		end

		add_index :commits, [:token], :unique => true
	end

	def self.down
		drop_table :commits
	end
end
