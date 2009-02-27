class CreateCommits < Ohdb::Migration  
	def self.up
		create_table :commits do |t|
			t.column :token,        :string, :null => false
			t.column :name,         :string
			t.column :date,         :datetime
			t.column :message_head, :string
			t.column :position,     :integer
		end

		add_index :commits, [:token],    :unique => true
		add_index :commits, [:position], :unique => true

		create_table :loc_deltas do |t|
			t.column :commit_id,        :integer, :null => false
			t.column :language,         :string,  :null => false
			t.column :code_added,       :integer, :null => false, :default => 0
			t.column :code_removed,     :integer, :null => false, :default => 0
			t.column :comments_added,   :integer, :null => false, :default => 0
			t.column :comments_removed, :integer, :null => false, :default => 0
			t.column :blanks_added,     :integer, :null => false, :default => 0
			t.column :blanks_removed,   :integer, :null => false, :default => 0
		end
		add_index :loc_deltas, [:commit_id]

		create_table :locs do |t|
			t.column :commit_id,  :integer, :null => false
			t.column :language,   :string,  :null => false
			t.column :filecount,  :integer, :null => false, :default => 0
			t.column :code,       :integer, :null => false, :default => 0
			t.column :comments,   :integer, :null => false, :default => 0
			t.column :blanks,     :integer, :null => false, :default => 0
		end
		add_index :locs, [:commit_id]

		create_table :months do |t|
			t.column :date, :datetime
			t.column :commit_id, :integer
		end

		create_table :tasks do |t|
			t.timestamps
			t.column :type, :string
			t.column :head_commit_id, :integer
			t.column :status, :string
			t.column :message, :text
		end
	end

	def self.down
		drop_table :tasks
		drop_table :loc_deltas
		drop_table :commits
	end
end
