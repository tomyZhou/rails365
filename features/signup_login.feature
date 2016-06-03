Feature: 登录

  Scenario: 非成功登录
    Given 用户查看登录页面
    When 提交无效的信息
    Then 应该看到错误显示

  Scenario: 成功登录
    Given 用户查看登录页面
      And 用户已经有登录账号
    When 用户提交有效的登录信息
    Then 用户应该看到成功的消息
      And 应该看到注销按钮
