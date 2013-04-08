task :default => [:test]

desc "Run all unit tests"
task :test do
    ruby "aiplayer_tests.rb"
    ruby "board_tests.rb"
    ruby "player_tests.rb < player_tests.txt"
    ruby "tic_tac_toe_tests.rb < tic_tac_toe_tests.txt"
end

desc "Play the game!"
task :play do
    ruby "play.rb"
end
