require_relative 'spec_helper'
require_relative 'spec_data'
require 'cgraph'
include Cgraph
describe Entity do
  after do
    Entity.clear_namelist
  end
  let(:e) {Entity.new "abc" }
  let(:f) {Entity.new "blub" }
  it "has automagic id" do
    e.id.must_be_instance_of Fixnum
    e.id.wont_equal f.id
  end
  it "must have a name" do
    e.name.must_equal "abc"
  end
  it "has a label" do
    e.label.must_equal "abc"
    e.label = "xyz"
    e.label.must_equal "xyz"
    e.name.must_equal "abc"
  end
  it "can have a group" do
    e.group.must_equal ""
    e.group = "woo"
    e.group.must_equal "woo"
  end
  it "should not allow same names" do
    Entity.new("blub")
    proc {Entity.new("blub")}.must_throw :same_name_error
  end
  it "can have a picture" do
    e.picture.must_equal ""
    e.picture = "link"
    e.picture.must_equal "link"
  end
  it "knows the outgoing connections" do
    e.outgoing.must_be_instance_of Array
  end
end

describe Graph do
  let(:g) {Graph.new TEST_CONNECTIONS, TEST_ENTITIES}

  it "should take an array, and a hash as parameter" do
    Graph.new [], {}
  end
  it "should create 3 Entities with the given data" do
    g.entities.count.must_equal 3
  end
  it "should find entity by name" do
    g.find_entity("peter").name.must_equal "peter"
  end
  it "should create connections between the entities" do
    g.connections.must_be_kind_of Array
    g.connections.count.must_be :>, 0
  end
  it "should generate an basic graphviz graph" do
    g.generate_graph.to_s.must_match /digraph/
  end
  it "should use the info data to enhance the entities" do
    g.generate_graph.find_node("peter").output
    g.find_entity("paul").picture.must_equal "logo_url"
  end
end
