import Foundation

public class LWWElementGraphChronology<T: Hashable> {
    
    public typealias Element = T
    
    public var addedValues: Set<LWWElementGraphChronologyDataStateModel<Element>>
    public var removedValues: Set<LWWElementGraphChronologyDataStateModel<Element>>
    
    
    public var vertices: Set<Vertex<Element>> {
        self.addedValues.setCompactMap { (item: LWWElementGraphChronologyDataStateModel<Element>) -> Vertex<Element>? in
            if let vertex = item.trackingItem.vertex, !isRemovedValue(trackingItem: .vertex(vertex)) {
                return vertex
            }
            return nil
        }
    }
    
    public var edges: Set<Edge<Element>> {
        self.addedValues.setCompactMap { (item: LWWElementGraphChronologyDataStateModel<Element>) -> Edge<Element>? in
            if let edge = item.trackingItem.edge,
               !isRemovedValue(trackingItem: .edge(edge)),
               !isRemovedValue(trackingItem: .vertex(edge.source)),
               !isRemovedValue(trackingItem: .vertex(edge.destination)){
                return edge
            }
            return nil
        }
    }
    
    public init(addedValues: Set<LWWElementGraphChronologyDataStateModel<Element>> = [],
                removedValues: Set<LWWElementGraphChronologyDataStateModel<Element>> = []) {
        
        self.addedValues = addedValues
        self.removedValues = removedValues
    }
    
    private func isRemovedValue(trackingItem: LWWEElementGraphChronologyTrackingItem<Element>) -> Bool {
       return removedValues.contains {
            return $0.trackingItem == trackingItem
        }
    }
    
    private func contains(trackingItem: LWWEElementGraphChronologyTrackingItem<Element>) -> Bool {
        
        return addedValues.contains {
            return $0.trackingItem == trackingItem
        } && !isRemovedValue(trackingItem: trackingItem)
    }
    
    // Filter arrays, removing dublicates by prioritising by timestamp
    private func filterUniqueArrayWithTimestamps(array: [LWWElementGraphChronologyDataStateModel<Element>]) -> Set<LWWElementGraphChronologyDataStateModel<Element>> {
        
        let finalArray = array.reduce([LWWElementGraphChronologyDataStateModel<Element>]()) { resultArray, element in
            var resultArray = resultArray
            if let index = resultArray.firstIndex(of: element) {
                if element.timeStamp > resultArray[index].timeStamp {
                    resultArray[index] = element
                }
            } else {
                resultArray.append(element)
            }
            return resultArray
        }
        return Set(finalArray)
    }
}

extension LWWElementGraphChronology: GraphChronology {
    
    public func addVertex(_ vertex: Vertex<Element>) {
        
        let existsInAddedVertices = addedValues.contains {
            return $0.trackingItem == .vertex(vertex)
        }
        
        let existsInDeletedValues = isRemovedValue(trackingItem: .vertex(vertex))
        
        if existsInAddedVertices || existsInDeletedValues {
            fatalError("You cannot add a vertex which already exists in the graph or was deleted before")
        }
        
        addedValues.insert(LWWElementGraphChronologyDataStateModel(trackingItem: .vertex(vertex)))
    }
    
    public func removeVertex(_ vertex: Vertex<Element>) {
        removedValues.insert(LWWElementGraphChronologyDataStateModel(trackingItem: .vertex(vertex)))
        for edge in edges(for: vertex) {
            removeEdge(edge)
        }
    }
    
    public func addEdge(_ edge: Edge<Element>) {
        addedValues.insert(LWWElementGraphChronologyDataStateModel(trackingItem: .edge(edge)))
    }
    
    public func removeEdge(_ edge: Edge<Element>) {
        removedValues.insert(LWWElementGraphChronologyDataStateModel(trackingItem: .edge(edge)))
    }
    
    public func containsVertex(_ vertex: Vertex<Element>) -> Bool {
        return self.contains(trackingItem: .vertex(vertex))
    }
    
    public func containsEdge(_ edge: Edge<Element>) -> Bool {
        return self.contains(trackingItem: .edge(edge))
    }
    
    public func edges(for vertex: Vertex<Element>) -> Set<Edge<Element>> {
        let values = self.addedValues.setCompactMap { (item: LWWElementGraphChronologyDataStateModel<Element>) -> Edge<Element>? in
            if let edge = item.trackingItem.edge, containsEdge(edge), edge.connectedToVertex(vertex) {
                return edge
            }
            return nil
        }
        return values
    }
    
    public func merge(with replicaChronology: LWWElementGraphChronology<Element>) -> Self {
        let comboAdd = Array(addedValues) + Array(replicaChronology.addedValues)
        let comboRemove = Array(removedValues) + Array(replicaChronology.removedValues)
        
        let newAddedValues = filterUniqueArrayWithTimestamps(array: comboAdd)
        let newRemovedValues = filterUniqueArrayWithTimestamps(array: comboRemove)
        
        return LWWElementGraphChronology<Element>(addedValues: newAddedValues, removedValues: newRemovedValues) as! Self
    }
}



extension LWWElementGraphChronology {
    public func copy() -> LWWElementGraphChronology {
        return LWWElementGraphChronology(addedValues: addedValues, removedValues: removedValues)
    }
}

extension Set {
    func setCompactMap<U>(transform: (Element) -> U?) -> Set<U> {
        return Set<U>(self.lazy.compactMap(transform))
    }
}
