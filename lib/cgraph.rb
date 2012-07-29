require 'graphviz'
module Cgraph
  class Entity
    @@count = 0
    @@names = []
    attr_accessor :picture, :outgoing, :label, :group
    attr_reader :name, :id
    def initialize name
      @name = Entity.check_name name
      @id = Entity.get_id
      @picture = ""
      @group = ""
      @outgoing = []
    end
    def self.clear_namelist
      @@names = []
    end
    def label
      return @name if @label.nil?
      @label
    end

  private
    def self.get_id
      @@count += 1
    end
    def self.check_name name
      throw :same_name_error if @@names.include? name
      @@names.push name
      name
    end
  end

  class Graph
    attr_reader :entities, :connections
    def initialize data, info
      Entity.clear_namelist
      @connections = []
      @entities = []
      generate_entities data, info
      generate_connections data
    end
    def generate_entities data, infos = nil
      data.flatten.uniq.each do |name|
        tmp = Entity.new name
        if !infos.nil? && !infos[name].nil?
          info = infos[name]
          tmp.label = info[:label] || ""
          tmp.picture = info[:picture] || ""
          tmp.group = info[:group] || ""
        end
        @entities.push tmp
      end
    end
    def generate_connections data
      @connections = data.group_by do |a,b|
        a+b; [a,b]
      end.map do |a,b|
        [a ,{count: b.count}]
      end
    end
    def find_entity name
      @entities.each do |e|
        return e if e.name == name
      end
    end
    def generate_graph
      graph = GraphViz.new(:G, :type => :digraph)
      graph = add_connections_to_graph graph
      graph.output(:png => "test.png")
      graph
    end
    def add_connections_to_graph graph
      @connections.each do |conn|
        p conn
        tupel = conn.first

        options = {penwidth: conn[1][:count]}
        graph.add_edges tupel[0],tupel[1],options
      end
      graph
    end

  end
end
