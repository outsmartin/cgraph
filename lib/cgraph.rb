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
    def initialize data, info, options={}
      Entity.clear_namelist
      @connections = []
      @entities = []
      @root = options[:root] || ""
      @no_penwidth = options[:penwidth] || false
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
    def add_entities graph
      @entities.each do |e|
        if e.picture
          graph.add_nodes e.name,label: "",image: e.picture
        else
          graph.add_nodes e.name, label: e.label
        end
      end
      graph
    end
    def generate_graph
      if @root
        graph = GraphViz.new(:G, :type => :digraph, :root => @root)
      else
        graph = GraphViz.new(:G, :type => :digraph)
      end
      graph = add_connections_to_graph graph
      graph = add_entities graph
      graph
    end
    def to_png
      graph.output(:png => "test.png")
    end
    def add_connections_to_graph graph
      @connections.each do |conn|
        tupel = conn.first
        options = {}

        if @no_penwidth
          options = {}
        else
          options = {style: calc_penwidth(conn[1][:count])}
        end

        graph.add_edges tupel[0],tupel[1],options
      end
      graph
    end
    def calc_penwidth(count)
      case count
      when 4..10 then 'dashed'
      when 11..1000 then 'solid'
      else
        'dotted'
      end
    end

  end
end
