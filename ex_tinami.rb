# coding: UTF-8
require './tinami.rb'
require './node'
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
    creator = self.creator_info(prof_id,tags)
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
  def get_data_from_tag(tag)
    creator_info = self.relation_search_tags(tag)['creator']
  end
  def create_tree_from_tag(tag,max_depth)
    tree = Tree.new
    #データを取ってくる
    data = self.get_data_from_tag(tag)
    #rootノードを作ってあげる
    root = tree.insert(nil,data)
    #検索したイラストのタグを取得
    tags = self.relation_search_tags(tag)['tag']
    self.for_search_and_insert(root,tags,tree,0,max_depth)
    return tree
  end
  def for_search_and_insert(parent,tags,tree,depth,max_depth)
    puts depth
    tags.each do |t|
      #イラストの情報を取ってくる
      data = self.get_data_from_tag(t)
      #取得したデータをtreeに追加(親ノードのtagsに追加)
      child = tree.insert(parent,data)
      #イラストのタグを取得
      tags = self.relation_search_tags(t)['tag']
      self.for_search_and_insert(child,tags,tree,depth+=1,max_depth)if depth<max_depth
    end
  end
end
