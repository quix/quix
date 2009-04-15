
task :depgraph, :root do |t, args|
  begin
    require 'graphviz'
  rescue LoadError
    require 'rubygems'
    require 'graphviz'
  end

  GraphViz.options(:use => "dot")

  graph = GraphViz.new("depgraph")
  nodes = Hash.new
  edges = Hash.new

  to_node_name = lambda { |str|
    str.gsub('/', '__').gsub('.', '_')
  }

  build_tree = lambda { |parent_object|
    parent = to_node_name.call(parent_object.name)
    nodes[parent] ||= graph.add_node(parent)
    parent_object.prerequisites.map { |unresolved_child|
      child_object = Rake.application[unresolved_child, parent_object.scope]
      child = to_node_name.call(child_object.name)
      edge_name = [parent, child].join("----")
      unless edges.has_key?(edge_name)
        edges[edge_name] = true
        nodes[child] ||= graph.add_node(child)
        graph.add_edge(nodes[parent], nodes[child])
        build_tree.call(child_object)
      end
    }
  }
  build_tree.call(Rake::Task[args.root || :default])
  
  graph.output(:output => "pdf", :file => "depgraph.pdf")
end

