import Foundation

public struct Edge<Element: Hashable> {
    
    public let source: Vertex<Element>
    public let destination: Vertex<Element>
    
    public init(source: Vertex<Element>, destination: Vertex<Element>) {
        self.source = source
        self.destination = destination
    }
    
    public func connectedToVertex(_ vertex: Vertex<Element>) -> Bool {
        return source == vertex || destination == vertex
    }
    
    var describingValue: String {
        return String("[\(source.describingValue) : \(destination.describingValue)] ")
    }
}

//MARK: - Hashable
extension Edge: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine("source_id:\(source.id)_destination:\(destination.id)")
    }
    
    static public func ==(lhs: Edge, rhs: Edge) -> Bool {
        return (lhs.source == rhs.source && lhs.destination == rhs.destination)
        ||
        (lhs.destination == rhs.source && lhs.source == rhs.destination)
    }
}
