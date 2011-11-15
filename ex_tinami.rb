# coding: UTF-8
class EXTinami < Tinami
  attr_reader :api_key, :email,:password,:auth_key,:users
  def create_tree_from_tag(tag,max_depth)
    tree = Tree.new
    #データを取ってくる
    data =  self.relation_search_tag(tag)
    #rootノードを作ってあげる
    root = tree.insert(nil,data['creator'])
    #検索したイラストのタグを取得
    tags = data['tag']
    self.for_search_and_insert(root,tags,tree,0,max_depth)
    return tree
  end
  def relation_search_tag(tag)
    #特定のタグの一番最近のイラストのcont_idをとる
    cont_id = self.content_search_by_tag(tag)
    #cont_idからそのイラストの情報を取得
    content = self.content_info(cont_id)
    prof_id = content.xpath('//creator').attribute('id').content
    creator = self.creator_info(prof_id,tag,content)
    #cont_idからそのイラストのタグ情報を取得
    tags = Array.new
    temp_tags = content.xpath("//tag")
    temp_tags.each do |t|
      #検索時に使ったtagは消去(あってもいいかも？)
      unless t.content==tag
      tags.push(t.content)
      end
    end
    return {'tag'=>tags,'creator'=>creator}
  end
  def for_search_and_insert(parent,tags,tree,depth,max_depth)
#    puts depth
    tags.each do |t|
      #イラストの情報を取ってくる
      data =  self.relation_search_tag(t)
      #取得したデータをtreeに追加(親ノードのtagsに追加)
      child = tree.insert(parent,data['creator'])
      #イラストのタグを取得
      tags = data['tag']
      self.for_search_and_insert(child,tags,tree,depth+=1,max_depth)if depth<max_depth
    end
  end
end
