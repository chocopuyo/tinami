# coding: UTF-8
class Tinami
#  attr_reader :api_key, :email,:password,:auth_key,:users
  require 'net/http'
  require 'rubygems'
  require 'nokogiri'
  Net::HTTP.version_1_2
  @@tinami_host = 'api.tinami.com'
  @@http = Net::HTTP.new(@@tinami_host,80)
  def initialize(arr)
    @api_key = arr['api_key']
    @email = arr['email']
    @password = arr['password']
    @users = Array.new
  end
  #認証する
  def auth
    response = @@http.post('/auth',"api_key=#{@api_key}&email=#{@email}&password=#{@password}").body
    doc = Nokogiri::XML(response)
    @auth_key = doc.at_css("auth_key").content
  end
  #ユーザー情報をとってくる
  def creator_info(prof_id,tag,content)
    response = @@http.post('/creator/info',"api_key=#{@api_key}&auth_key=#{@auth_key}&prof_id=#{prof_id}").body
    doc = Nokogiri::XML(response)
    data = {
      'name'=>doc.xpath('//name')[0].content,
      'thumbnail'=>doc.xpath('//thumbnail')[0].content,
      'user_id' => prof_id,
      'title' => content.xpath('//title')[0].content,
      'image' => content.xpath('//image/url')[0].content,
      'tag'=>tag
    }
    @users.push(data)
    return data
  end
  #タグを使って、画像を探す(認証なし)
  def content_search_by_tag(tag)
    response = @@http.post('/content/search',"api_key=#{@api_key}&tags=#{tag}&cont_type[]=1").body
    doc = Nokogiri::XML(response)
    contents = doc.xpath('//content')
    #検索数HIT数(MAX20)
    size = contents.size
    #検索したものからランダムにID抽出
    result = contents[rand(size)].attribute('id')
    return result
  end
  #作品情報の取得(認証なし)
  def content_info(cont_id)
    response = @@http.post('/content/info',"api_key=#{@api_key}&auth_key=#{@auth_key}&cont_id=#{cont_id}").body
    doc = Nokogiri::XML(response)
  end
end

