import Foundation

public enum LWWEElementGraphChronologyTrackingItem<Element: Hashable> {
    
    case vertex(Vertex<Element>)
    case edge(Edge<Element>)
    
    var vertex: Vertex<Element>? {
        switch self {
        case .vertex(let vertex):
            return vertex
        default:
            return nil
        }
    }
    
    var edge: Edge<Element>? {
        switch self {
        case .edge(let edge):
            return edge
        default:
            return nil
        }
    }
}

extension LWWEElementGraphChronologyTrackingItem: Equatable {
    
    public static func ==(lhs: LWWEElementGraphChronologyTrackingItem<Element>, rhs: LWWEElementGraphChronologyTrackingItem<Element>) -> Bool {
        
        if let lhsVertex = lhs.vertex, let rhsVertex = rhs.vertex, lhsVertex == rhsVertex {
            return true
        }
        
        if let lhsEdge = lhs.edge, let rhsEdge = rhs.edge, lhsEdge == rhsEdge {
            return true
        }
        
        return false
    }
}
