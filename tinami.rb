# coding: UTF-8
class Tinami
  attr_reader :api_key, :email,:password,:auth_key
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
  end
  #認証する
  def auth
    response = @@http.post('/auth',"api_key=#{@api_key}&email=#{@email}&password=#{@password}").body
    doc = Nokogiri::XML(response)
    @auth_key = doc.at_css("auth_key").content
  end
  #ユーザー情報をとってくる
  def creator_info(prof_id)
    response = @@http.post('/creator/info',"api_key=#{@api_key}&auth_key=#{@auth_key}&prof_id=#{prof_id}").body
    doc = Nokogiri::XML(response)
    {
      'name'=>doc.at_css('name').content,
      'thumbnail'=>doc.at_css('thumbnail').content
    }
  end
  def content_search(tags)
    response = @@http.post('/content/search',"api_key=#{@api_key}&auth_key=#{@auth_key}&tags=#{tags}&cont_type[]=1").body
    doc = Nokogiri::XML(response)
  end
end

