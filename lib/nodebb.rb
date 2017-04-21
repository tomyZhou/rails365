require 'net/http'
require 'uri'

class Nodebb
  def self.create_category(name)
    puts "处理group:#{name}中..."
    uri = URI.parse("https://nodebb.rails365.net/api/v1/categories")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer 16b4c20a-2880-4075-a0aa-964d2d76acff"
    request.set_form_data(
      "name" => name,
    )

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    result = JSON.parse response.body

    if result['code'] == 'ok'
      puts "group:#{name}返回成功"
      return result['payload']['cid']
    else
      puts "group:#{name}返回失败"
    end
  end

  def self.create_topic(cid, title, content)
    puts "处理article-#{title}中..."
    uri = URI.parse("https://nodebb.rails365.net/api/v1/topics")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer 16b4c20a-2880-4075-a0aa-964d2d76acff"
    request.body = "cid=#{cid}&title=#{title}&content=#{content}"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    result = JSON.parse response.body

    if result['code'] == 'ok'
      puts "article:#{title}返回成功"
    else
      puts "article:#{title}返回失败"
    end
  end

  def self.create_all_article
    Group.all.each do |group|
      cid = self.create_category(group.name)
      if cid
        group.articles.each do |article|
          self.create_topic(cid, article.title, article.body)
        end
      end
    end
  end
end
