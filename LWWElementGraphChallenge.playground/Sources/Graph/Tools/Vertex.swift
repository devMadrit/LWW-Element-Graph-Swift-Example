import Foundation

public struct Vertex<T: Hashable> {
    
    /// Unique ID For the vertex, it is supposed it will be unique once created, even within replicas
    public let id = UUID().uuidString
    public let value: T
    
    public init(value: T) {
        self.value = value
    }
    
    var describingValue: String {
        return "\(value)"
    }
}

//MARK: - Hashable
extension Vertex: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.id == rhs.id
    }
}
