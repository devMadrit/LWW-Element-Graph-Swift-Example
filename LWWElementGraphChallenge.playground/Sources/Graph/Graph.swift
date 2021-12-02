import Foundation

public protocol Graph: AnyObject {
    
    associatedtype Element: Hashable
    
    func addVertex(_ vertex: Vertex<Element>)
    func removeVertex(_ vertex: Vertex<Element>)
    
    func addEdge(_ edge: Edge<Element>)
    func addEdge(sourceVertex: Vertex<Element>, destinationVertex: Vertex<Element>)
    func removeEdge(_ edge: Edge<Element>)
    
    func contains(vertex: Vertex<Element>) -> Bool
    func contains(edge: Edge<Element>) -> Bool
    
    func connectedVertices(to currentVertex: Vertex<Element>) -> [Vertex<Element>]
    
    func describedPath(startVertex: Vertex<Element>, endVertex: Vertex<Element>) -> String
    
    func merge(with replica: Self) -> Self
}
