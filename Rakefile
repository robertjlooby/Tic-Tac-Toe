require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |t|
    t.test_files = FileList['./tests/*']
end

desc "Play the game!"
task :play do
    ruby "./src/play.rb"
end
