class CreateCommits < Ohdb::Migration  
	def self.up
		create_table :commits do |t|
			t.column :token, :string, :null => false
			t.column :name, :string
			t.column :date, :datetime
			t.column :message_head, :string
			t.column :position, :integer
		end

		add_index :commits, [:token], :unique => true
		add_index :commits, [:position], :unique => true

		create_table :imports do |t|
			t.timestamps
			t.column :head_commit_id, :integer
			t.column :status, :string
			t.column :message, :text
		end
	end

	def self.down
		drop_table :commits
	end
end
