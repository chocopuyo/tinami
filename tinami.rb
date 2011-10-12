# coding: UTF-8
class Tinami
  attr_reader :api_key, :email,:password,:auth_key
  require 'net/http'
  require 'rubygems'
  require 'nokogiri'
  Net::HTTP.version_1_2
  @@tinami_host = 'api.tinami.com'
  @@http = Net::HTTP.new(@@tinami_host,80)
=begin
  @@url = {
#response = http.post('/auth',)
    'auth' =>tinami_host+'/auth',
    'login'=>tinami_host+'/login/info',
    'logout'=>tinami_host+'/logout',
    'search'=>tinami_host+'/content/search',
    'bookmark_creator'=>tinami_host+'/bookmark/content/list',
    'friend'=>tinami_host+'/friend/recommend/content/list',
    'watchkeyword'=>tinami_host+'/watchkeyword/content/list',
    'collection'=>tinami_host+'/collection/list',
    'collection_add'=>tinami_host+'/collection/add',
    'bookmark'=>tinami_host+'/bookmark/list',
    'bookmark_add'=>tinami_host+'/bookmark/add',
    'ranking'=>tinami_host+'/ranking',
    'content'=>tinami_host+'/content/info',
    'creator'=>tinami_host+'/creator/info',
    'comment'=>tinami_host+'/content/comment/list',
    'comment_add'=>tinami_host+'/content/comment/add',
    'comment_remove'=>tinami_host+'/content/comment/remove',
    'support'=>tinami_host+'/content/support',
  }
=end
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
  def create_info
  end
end

