## README

分享文章和视频 http://rails365.net

### 依赖:

* rails 4

* postgresql

* redis

### 安装:

```
bundle install
cp config/database.yml.example config/database.yml
cp config/application.yml.example config/application.yml
```

以下是安装postgresql的中文扩展

#### 第一步，安装**SCWS**

``` bash
# 下载并解压
wget -q -O - http://www.xunsearch.com/scws/down/scws-1.2.2.tar.bz2 | tar xvjf -
# 编译安装
cd scws-1.2.2 ; ./configure ; sudo make install
```

#### 第二步，编译和安装zhparser

``` bash
# 先安装PostgreSQL的扩展包
sudo apt-get install postgresql-server-dev-9.3
git clone https://github.com/amutu/zhparser.git
cd zhparser
SCWS_HOME=/usr/local make && sudo make install
```

#### 第三步，进入数据库安装扩展

``` bash
# 进入数据库
sudo -u postgres psql
# 连接数据库
\c rails365_pro
# 安装扩展
CREATE EXTENSION zhparser;
CREATE TEXT SEARCH CONFIGURATION testzhcfg (PARSER = zhparser);
ALTER TEXT SEARCH CONFIGURATION testzhcfg ADD MAPPING FOR n,v,a,i,e,l WITH simple;
```

### 参与开发

联系我(hfpp2012@aliyun.com)加入trello
