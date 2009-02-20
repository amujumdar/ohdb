require 'rake'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'

Rake::TestTask.new :units do |t|
	# puts File.dirname(__FILE__) + '/test/unit/*_test.rb'
	t.test_files = FileList[File.join(File.dirname(__FILE__), '/test/unit/**/*_test.rb')]
	# t.verbose = true
end

task :default => :units
