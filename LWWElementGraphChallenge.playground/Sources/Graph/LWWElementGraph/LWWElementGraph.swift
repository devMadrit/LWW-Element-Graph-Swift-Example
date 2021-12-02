import Foundation

public class LWWElementGraph<T: Hashable> {
    
    public typealias Element = T
    
    public let graphChronology: LWWElementGraphChronology<Element>
    
    public init(graphChronology: LWWElementGraphChronology<Element> = LWWElementGraphChronology()) {
        self.graphChronology = graphChronology
    }
    
    public func edges(for source: Vertex<Element>) -> Set<Edge<Element>> {
        return graphChronology.edges(for: source)
    }
    
    public func printGraphDescription(graphTitle: String) {
        print("--------------------------------------------------------------------")
        print("\(graphTitle)")
        print ("Vertices:")
        print(graphChronology.vertices.map { "\($0.value)" }.joined(separator: ","))
        print ("Edges:")
        print(graphChronology.edges.map { "[\($0.source.value) : \($0.destination.value)]" }.joined(separator: ","))
        print("--------------------------------------------------------------------")
    }
}

extension LWWElementGraph: Graph {
    
    public func addVertex(_ vertex: Vertex<Element>){
        graphChronology.addVertex(vertex)
    }
    
    public func removeVertex(_ vertex: Vertex<Element>) {
        graphChronology.removeVertex(vertex)
    }
    
    public func addEdge(sourceVertex: Vertex<Element>, destinationVertex: Vertex<Element>) {
        let edge = Edge<Element>(source: sourceVertex, destination: destinationVertex)
        addEdge(edge)
    }
    
    public func addEdge(_ edge: Edge<Element>) {
        graphChronology.addEdge(edge)
    }
    
    public func removeEdge(_ edge: Edge<Element>){
        graphChronology.removeEdge(edge)
    }
    
    public func contains(vertex: Vertex<Element>) -> Bool {
        return graphChronology.containsVertex(vertex)
    }
    
    public func contains(edge: Edge<Element>) -> Bool {
        return graphChronology.containsEdge(edge)
    }
    
    public func connectedVertices(to currentVertex: Vertex<Element>) -> [Vertex<Element>] {
        
        // Check in case this vertex exists and the graph contains it
        guard self.contains(vertex: currentVertex) else {
            return []
        }
        
        /* Loop through the edges to find the vertex that could be the source or destination
         which is not the ** @parameter currentVertex ** that we are searching for. */
        
        return self.edges(for: currentVertex).compactMap { (edge: Edge<Element>) -> Vertex<Element>? in
            
            guard self.contains(edge: edge) else {
                return nil
            }
            
            if edge.source != currentVertex {
                return edge.source
            }
            
            return edge.destination
        }
    }
    
    public func merge(with replica: LWWElementGraph<Element>) -> Self {
        return LWWElementGraph(graphChronology: graphChronology.merge(with: replica.graphChronology)) as! Self
    }
    
    public func describedPath(startVertex: Vertex<Element>, endVertex: Vertex<Element>) -> String {
        let pathEdges = pathBetween(startVertex: startVertex, endVertex: endVertex)
        return pathEdges
            .map { "[\($0.source.value) : \($0.destination.value)]" }
            .joined(separator: ",")
    }
}

//MARK: Path calculator
extension LWWElementGraph {
    
    public func pathBetween(startVertex: Vertex<Element>, endVertex: Vertex<Element>) -> [Edge<Element>] {
        
        guard startVertex != endVertex, contains(vertex: startVertex), contains(vertex: endVertex) else {
            return []
        }
        return findPathBetween(startVertex: startVertex, endVertex: endVertex).walkingPath ?? []
    }
    
    private func findPathBetween(walkingPath: [Edge<Element>]? = nil, startVertex: Vertex<Element>, endVertex: Vertex<Element>) -> (path: Edge<Element>?, walkingPath: [Edge<Element>]?)  {
        
        for edge in self.edges(for: startVertex) {
            
            var paths = walkingPath ?? []
            
            if paths.contains(edge) {
                // we are looping around, we need to stop this
                continue
            }
            
            var nextVertex: Vertex<Element>
            if edge.source != startVertex {
                nextVertex = edge.source
            } else {
                nextVertex = edge.destination
            }
            
            //Mark: TODO Check if wee need to put this line after the if below
            let structuredEdge = Edge(source: startVertex, destination: nextVertex)
            paths.append(structuredEdge)
            if nextVertex == endVertex {
                // we found it
                return (edge, paths)
            }
            
            // we loop again
            let recursivePath = self.findPathBetween(walkingPath: paths, startVertex: nextVertex, endVertex: endVertex)
            if recursivePath.path != nil {
                return recursivePath
            }
        }
        return (nil, nil)
    }
}

extension LWWElementGraph {
    
    public func copy() -> LWWElementGraph {
        return LWWElementGraph(graphChronology: self.graphChronology.copy())
    }
}
