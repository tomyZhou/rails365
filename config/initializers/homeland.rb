Homeland.configure do
  # 正文格式化方式, [:markdown, :plain, :html], 默认: :markdown
  self.markup = :ruby_china

  # 应用名称
  # self.app_name = 'Homeland'

  # 分页每页条数
  # self.per_page = 32

  # 重要！用户 Model 的 Model 名称, 默认: 'User'
  # self.user_class = 'User'

  # 在 User model 里面表示用户姓名、昵称的函数名称。
  # 用于 Homeland 页面显示发帖回帖人名称, 默认: 'name'
  # 例如:
  # class User
  #   def name
  #     self.email.split('@').first
  #   end
  # end
  self.user_name_method = 'username'

  # 在 User model 里面，用户头像 URL 的函数名称，默认: nil
  # 当这个参数 nil 的时候，我们会用一个默认头像在页面上显示
  # 关于尺寸，请给至少 64x64 以上
  # self.user_avatar_url_method = nil

  # 在 User model 里面，检测用户是否有 Homeland 管理权限的函数，默认: 'admin?'
  # 此函数目的是为了告诉 Homeland，此用户是否可以管理论坛的回帖发帖，请返回 true, false
  self.user_admin_method = 'super_admin?'

  # 在 User model 里面提供用户个人页面 URL（用于页面上点击用户名、头像的目标页面）
  # 默认: 'profile_url'
  # self.user_profile_url_method = 'profile_url'

  # 在 Controller 里面，检查限制必须登录的函数（参见 Devise 的 authenticate_user! 方法）
  # 默认: 'authenticate_user!'
  # 此方法要求检查用户是否登录，未登录跳转到登录页面
  # self.authenticate_user_method = 'authenticate_user!'

  # 在 Controller 里面，获取当前用户对象的函数（参加 Devise 的 current_user 方法)
  # 默认: 'current_user'
  # 要求这个函数返回一个 User 对象
  # self.current_user_method = 'current_user'
end
