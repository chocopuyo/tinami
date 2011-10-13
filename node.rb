# coding: UTF-8
class Tree
  attr_accessor :root
  class Node
    attr_accessor :data,:tags
    def initialize(data)
      @data = data
      @tags = Array.new
    end
  end
  def initialize
    @root = nil
  end
  def insert(parent,data)
    if parent == nil
      parent = Node.new(data)
      @root = parent
      return parent 
    else
      child = Node.new(data)
      parent.tags.push(child)
      return child
    end
  end
end
