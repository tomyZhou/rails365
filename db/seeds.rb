puts '网站名称'
Admin::SiteInfo.find_or_create_by(key: 'name') do |cp|
  cp.value = 'Rails365'
  cp.desc = '网站名称'
end

puts '网站标题'
Admin::SiteInfo.find_or_create_by(key: 'title') do |cp|
  cp.value = 'Rails365-分享linux, nginx，redis，postgresql，ruby优秀文章'
  cp.desc = "网站标题"
end

puts '网站描述'
Admin::SiteInfo.find_or_create_by(key: 'meta_description') do |cp|
  cp.value = 'rails365.net是一家致力于分享前端，后端，服务器等文章的网站'
  cp.desc = '网站描述'
end

puts '网站关键字'
Admin::SiteInfo.find_or_create_by(key: 'meta_keyword') do |cp|
  cp.value = 'linux, nginx, redis, ruby, 文章'
  cp.desc = '网站关键字'
end

puts "首页banner宣传文字"
Admin::SiteInfo.find_or_create_by(key: 'home_desc') do |cp|
  cp.value = '本站致力于分享nginx, ruby on rails, 运维, 服务器, 架构, postgresql, redis, 日志, 多线程, 消息队列, vim, git, 前端javascript等优秀文章, 且保持高更新频率'
  cp.desc = '首页banner宣传文字'
end

puts "Top 10 视频播放量自动增长开关"
Admin::SiteInfo.find_or_create_by(key: 'top_10_video_auto_increment') do |cp|
  cp.value = '开启'
  cp.desc = "如果为 空 就是关闭，否则任意字符串开启"
end

puts "Top 10 文章点击量自动增长开关"
Admin::SiteInfo.find_or_create_by(key: 'top_10_article_auto_increment') do |cp|
  cp.value = '开启'
  cp.desc = "如果为 空 就是关闭，否则任意字符串开启"
end

puts "Top n 视频播放量"
Admin::SiteInfo.find_or_create_by(key: 'top_n_video_auto_increment') do |cp|
  cp.value = '10'
  cp.desc = "数字，取最后 n 后"
end

puts "Top n 文章点击量"
Admin::SiteInfo.find_or_create_by(key: 'top_n_article_auto_increment') do |cp|
  cp.value = '10'
  cp.desc = "数字，取最后 n 后"
end

puts "访问视频 ws 通知控制"
Admin::SiteInfo.find_or_create_by(key: 'guest_access_movie') do |cp|
  cp.value = '空'
  cp.desc = "如果为 空 就是关闭，否则任意字符串开"
end
