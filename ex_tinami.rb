# coding: UTF-8
require './tinami.rb'
class EXTinami < Tinami
  attr_reader :api_key, :email,:password,:auth_key
  def relation_search_tags(tags)
    #特定のタグの一番最近のイラストのcont_idをとる
    doc = self.content_search({'tags'=>tags})
    cont_id = doc.xpath('//content')[rand(3)].attribute("id")
    cont = self.content_tags(cont_id)
    #cont_idからそのイラストのクリエーター情報を取得
    cont = self.content_info(cont_id)
    prof_id = cont.at_css('creator').get_attribute("id")
    creator = self.creator_info(prof_id)
    #cont_idからそのイラストのタグ情報を取得
    tag = Array.new
    cont.xpath("//tag").each do |t|
      #検索時に使ったtagは消去(あってもいいかも？)
      unless t.content==tags
      tag.push(t.content)
      end
    end
    return {'tag'=>tag,'creator'=>creator}
  end
end
