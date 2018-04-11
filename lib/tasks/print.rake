namespace :print do
  desc "puts all movies"
  task all_movies_list: :environment do
    Playlist.all_movies_list
  end
end

# https://stackoverflow.com/questions/825748/how-to-pass-command-line-arguments-to-a-rake-task?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
# 调用 bundle exec rake 'print:playlist_movies_list[诱人的 react 视频教程-基础篇]'
namespace :print do
  desc "puts all movies"
  task :playlist_movies_list, [:name] => [:environment] do |task, args|
    Playlist.playlist_movies_list(args[:name])
  end
end
