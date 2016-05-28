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
