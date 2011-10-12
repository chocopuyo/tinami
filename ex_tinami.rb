# coding: UTF-8
require './tinami.rb'
class EXTinami < Tinami
  def relation_search(tags)
    doc = self.content_search(tags)
    doc.at_css('content').get_attribute("id")
    #'thumbnail'=>doc.at_css('thumbnail').content
  end
end
