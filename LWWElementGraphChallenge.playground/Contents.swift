import Foundation

//MARK: - Main Setup

let baseGraph = LWWElementGraph<Int>()

 // 1. Create Vertices and Add them to the graph
let vertex1 = Vertex(value: 1)
let vertex2 = Vertex(value: 2)
let vertex3 = Vertex(value: 3)
let vertex4 = Vertex(value: 4)
let vertex5 = Vertex(value: 5)

let edge1_5 = Edge(source: vertex1, destination: vertex5)
let edge1_3 = Edge(source: vertex1, destination: vertex3)
let edge2_3 = Edge(source: vertex2, destination: vertex3)
let edge3_4 = Edge(source: vertex3, destination: vertex4)
let edge4_5 = Edge(source: vertex4, destination: vertex5)

// 3. Fake Items
let fakeVertex = Vertex(value: 15)
let fakeEdge = Edge(source: vertex4, destination: vertex1)

// MARK: - 1. add a vertex/edge,

baseGraph.addVertex(vertex1)
baseGraph.addVertex(vertex2)
baseGraph.addVertex(vertex3)
baseGraph.addVertex(vertex4)
baseGraph.addVertex(vertex5)

baseGraph.addEdge(edge1_5)
baseGraph.addEdge(edge1_3)
baseGraph.addEdge(edge2_3)
baseGraph.addEdge(edge3_4)
baseGraph.addEdge(edge4_5)

// Print result
print("1. Add a vertex/edge")
baseGraph.printGraphDescription(graphTitle: "BaseGraph")
print("\n \n \n")

// MARK: - 2. remove a vertex/edge
func removeVertexTest() {
    
    print("2. Remove a vertex/edge")
    print("--------------------------------------------------------------------")
    let graph1 = baseGraph.copy()
    
    graph1.removeVertex(vertex4)
    graph1.removeEdge(edge2_3)
    
    graph1.printGraphDescription(graphTitle: "Removed vertex 4 and edge[2:3]")
    print("\n")
    // Second Example
    let graph2 = graph1.copy()
    graph2.removeVertex(vertex3)
    graph2.printGraphDescription(graphTitle: "Removed vertex 3")
    print("--------------------------------------------------------------------")
    print("\n \n \n")
}
removeVertexTest()
// MARK: - 3. check if a vertex is in the graph,

func checkVertexIsInGraphTest() {
    print("3. Check if a vertex is in the graph")
    print("--------------------------------------------------------------------")
    print("Vertex 2 is in baseGraph: " + "\(baseGraph.contains(vertex: vertex2))")
    print("Edge [2:3] is in baseGraph: " + "\(baseGraph.contains(edge: edge2_3))")
    
    print("Fake Vertex is in baseGraph: " + "\(baseGraph.contains(vertex: fakeVertex)))")
    print("Fake Edge is in baseGraph: " + "\(baseGraph.contains(edge: fakeEdge))")
    print("--------------------------------------------------------------------")
    print("\n \n \n")
}

checkVertexIsInGraphTest() // call the test

// MARK: - 4. Query for all vertices connected to a vertex,

func allVerticlesConnectedToGraphTest() {
    print("4. Query for all vertices connected to a vertex")
    print("--------------------------------------------------------------------")
    print("Vertices connected to vertex 3 :")
    let verticesConnectedToVertex3 = baseGraph.connectedVertices(to: vertex3).map { "\($0.value)" }.joined(separator: ",")
    print(verticesConnectedToVertex3)
    print("--------------------------------------------------------------------")
    print("\n \n \n")
}

allVerticlesConnectedToGraphTest() // call the test

// MARK: - 5. Find any path between two vertices

func pathBetweenTwoVerticesTest() {
    
    let graph = baseGraph.copy()
    
    print("5. Find any path between two vertices")
    print("--------------------------------------------------------------------")
    print("Path between vertex 1 and vertex 2")
    print(graph.describedPath(startVertex: vertex1, endVertex: vertex2))
    
    graph.removeEdge(edge2_3)
    print("Path between vertex 1 and vertex 2 after removing Edge [2:3], should be empty:")
    print(graph.describedPath(startVertex: vertex1, endVertex: vertex2))
    
    let vertex6 = Vertex(value: 6)
    let edge1_6 = Edge(source: vertex1, destination: vertex6)
    graph.addVertex(vertex6)
    graph.addEdge(edge1_6)
    print("Path between vertex 4 and vertex 6 after adding vertex 6 and Edge [1:6]:")
    print(graph.describedPath(startVertex: vertex4, endVertex: vertex6))
    
    print("Path between vertex 1 and vertex 1, which shouldn't exist because of no edges, should be empty:")
    print(graph.describedPath(startVertex: vertex1, endVertex: vertex1))
    print("--------------------------------------------------------------------")
    print("\n \n \n")
}

pathBetweenTwoVerticesTest() // call the test

//MARK: - 6. Merge with concurrent changes from other graph/replica.

func mergeConcurrentPathTest() {
    
    print("6. Merge with concurrent changes from other graph/replica.")
    
    var graphA = baseGraph.copy()
    var graphB = baseGraph.copy()
    
    print("--------------------------------------------------------------------")
    print("Simple case, Add vertex 6 to the graphA with add edge [4:6]. Remove vertex 2 from GraphB")
    
    let vertex6 = Vertex(value: 6)
    let edge4_6 = Edge(source: vertex4, destination: vertex6)
    graphA.addVertex(vertex6)
    graphA.addEdge(edge4_6)
    graphA.printGraphDescription(graphTitle: "Graph A:")
    graphB.removeVertex(vertex2)
    graphB.printGraphDescription(graphTitle: "Graph B:")
    
    let mergedGraph = graphA.merge(with: graphB)
    print("Result of the merge:")
    mergedGraph.printGraphDescription(graphTitle: "Merged graphAB")
    print("\n")
    print("Sync graph A and graph B with the merged graph above.")
    graphA = mergedGraph.copy()
    graphB = mergedGraph.copy()
    print("Conflict case, remove vertex 1 from graphA. Add vertex 7 with edge [1:7] to graphB")
   
    graphA.removeVertex(vertex1)
    graphA.printGraphDescription(graphTitle: "Graph A:")
    
    let vertex7 = Vertex(value: 7)
    let edge1_7 = Edge(source: vertex1, destination: vertex7)
    graphB.addVertex(vertex7)
    graphB.addEdge(edge1_7)
    graphB.printGraphDescription(graphTitle: "Graph B:")

    let newMergedGraph = graphA.merge(with: graphB)
    
    print("Result of the new merge:")
    newMergedGraph.printGraphDescription(graphTitle: "New: Merged graphAB")
    
    print("--------------------------------------------------------------------")
}
mergeConcurrentPathTest() // call the test

