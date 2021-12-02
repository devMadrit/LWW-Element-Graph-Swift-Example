import Foundation

public protocol GraphChronology: AnyObject {
    
    associatedtype Element: Hashable
    
    func addVertex(_ vertex: Vertex<Element>)
    func removeVertex(_ vertex: Vertex<Element>)
    
    func addEdge(_ edge: Edge<Element>)
    func removeEdge(_ edge: Edge<Element>)
    
    func containsVertex(_ vertex: Vertex<Element>) -> Bool
    func containsEdge(_ edge: Edge<Element>) -> Bool
    
    func edges(for vertex: Vertex<Element>) -> Set<Edge<Element>>
    func merge(with replicaChronology: Self) -> Self
}
