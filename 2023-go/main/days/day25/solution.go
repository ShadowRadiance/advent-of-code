package day25

import (
	"cmp"
	"fmt"
	"math"
	"slices"
	"strconv"
	"strings"

	"github.com/shadowradiance/advent-of-code/2023-go/util"
)

type Vertex struct {
	name  string
	edges []*Edge
}

func (v *Vertex) String() string {
	return v.name
	// return fmt.Sprintf("%s %v", v.name, v.edges)
}

type Edge struct {
	a      *Vertex
	b      *Vertex
	weight int
}

func (e *Edge) String() string {
	return fmt.Sprintf("%s/%s", e.a.name, e.b.name)
}

func (e *Edge) canonicalize() *Edge {
	vertices := []*Vertex{e.a, e.b}
	slices.SortFunc(vertices, func(a, b *Vertex) int { return cmp.Compare(a.name, b.name) })
	e.a = vertices[0]
	e.b = vertices[1]
	return e
}

func (e *Edge) otherEndFrom(vertex *Vertex) *Vertex {
	if e.a == vertex {
		return e.b
	}
	return e.a
}

type Graph = map[string]*Vertex
type StringSet = map[string]bool

func parseLines(lines []string) (vertices Graph, edges []*Edge) {
	vertices = map[string]*Vertex{}
	edges = make([]*Edge, 0)

	for _, line := range lines {
		parts := strings.Split(line, ": ")
		rootName := parts[0]
		connectedNames := strings.Split(strings.TrimSpace(parts[1]), " ")

		rootVertex := findOrCreateVertex(rootName, vertices)
		for _, name := range connectedNames {
			connectedVertex := findOrCreateVertex(name, vertices)
			edge := &Edge{a: rootVertex, b: connectedVertex}
			edge.canonicalize()
			edges = append(edges, edge)
			rootVertex.edges = append(rootVertex.edges, edge)
			connectedVertex.edges = append(connectedVertex.edges, edge)
		}
	}
	return
}

func findOrCreateVertex(name string, vertices map[string]*Vertex) *Vertex {
	if _, ok := vertices[name]; !ok {
		vertices[name] = &Vertex{name: name, edges: make([]*Edge, 0)}
	}
	return vertices[name]
}

func countConnected(vertex *Vertex, seen map[*Vertex]bool) (count int) {
	if seen[vertex] {
		return 0
	}

	seen[vertex] = true
	count = 1
	for _, edge := range vertex.edges {
		vOther := edge.otherEndFrom(vertex)
		count += countConnected(vOther, seen)
	}
	return
}

func FloydWarshallWithPath(
	vertices []*Vertex,
	edges []*Edge,
) (
	dist map[*Vertex]map[*Vertex]float64,
	prev map[*Vertex]map[*Vertex]*Vertex,
) {
	var V = len(vertices)
	w := func(u, v *Vertex) float64 { return 1.0 }

	// let dist be a |V|×|V| array of minimum distances initialized to ∞ (infinity)
	dist = map[*Vertex]map[*Vertex]float64{}
	for _, v := range vertices {
		dist[v] = map[*Vertex]float64{}
		for _, vv := range vertices {
			dist[v][vv] = math.Inf(1)
		}
	}
	// let prev be a |V|×|V| array of vertex indices initialized to null
	prev = map[*Vertex]map[*Vertex]*Vertex{}
	for _, v := range vertices {
		prev[v] = map[*Vertex]*Vertex{}
		for _, vv := range vertices {
			prev[v][vv] = nil
		}
	}

	// for each edge (u, v) do
	//     dist[u][v] ← w(u, v)  // The weight of the edge (u, v)
	//     prev[u][v] ← u
	for _, e := range edges {
		u := e.a
		v := e.b
		dist[u][v] = w(u, v)
		prev[u][v] = u
	}

	// for each vertex v do
	//     dist[v][v] ← 0
	//     prev[v][v] ← v
	for _, v := range vertices {
		dist[v][v] = 0.0
		prev[v][v] = v
	}

	// for k from 1 to |V| do // standard Floyd-Warshall implementation
	//     for i from 1 to |V|
	//         for j from 1 to |V|
	//             if dist[i][j] > dist[i][k] + dist[k][j] then
	//                 dist[i][j] ← dist[i][k] + dist[k][j]
	//                 prev[i][j] ← prev[k][j]
	for k := 0; k < V; k++ {
		kk := vertices[k]
		for i := 0; i < V; i++ {
			ii := vertices[i]
			for j := 0; j < V; j++ {
				jj := vertices[j]

				if dist[ii][jj] > dist[ii][kk]+dist[kk][jj] {
					dist[ii][jj] = dist[ii][kk] + dist[kk][jj]
					prev[ii][jj] = prev[kk][jj]
				}
			}
		}
	}

	return
}

func FloydWarshallReconstructPath(u, v *Vertex, prev map[*Vertex]map[*Vertex]*Vertex) (path []*Vertex) {
	if prev[u][v] == nil {
		return
	}

	path = []*Vertex{v}
	for u != v {
		v = prev[u][v]
		path = append([]*Vertex{v}, path...)
	}
	return path
}

type Solution struct{}

func (Solution) Part01(input string) string {
	lines := strings.Split(strings.TrimSpace(input), "\n")
	if len(lines) == 0 {
		return "NO DATA"
	}

	graph, edges := parseLines(lines)

	var sideA, sideB, result int

	// for every pair of vertices,
	// 	find the shortest path between them,
	// 	remembering the times each edge is visited
	// the three most-commonly used edges are the bottleneck we need to cut
	vertices := util.MapValues(graph)

	fmt.Println("Finding shortest paths for all pairs")
	_, previousMap := FloydWarshallWithPath(vertices, edges)

	fmt.Println("Walk the shortest path for each pair of vertices, recording each edge-hit as a weight in edges")
	for i := 0; i < len(vertices)-1; i++ {
		for j := i + 1; j < len(vertices); j++ {
			vertexPath := FloydWarshallReconstructPath(vertices[i], vertices[j], previousMap)
			walkPath(vertexPath)
		}
	}

	fmt.Println("Finding 3 most travelled edges")
	slices.SortFunc(edges, func(a, b *Edge) int { return -cmp.Compare(a.weight, b.weight) })
	top3, edges := edges[:3], edges[3:]

	fmt.Println(top3)

	fmt.Println("Cutting 3 most travelled edges")
	for _, edge := range top3 {
		// remove edge
		vertexA := edge.a
		vertexB := edge.b
		equal := func(e *Edge) bool { return e == edge }
		vertexA.edges = slices.DeleteFunc(vertexA.edges, equal)
		vertexB.edges = slices.DeleteFunc(vertexB.edges, equal)
	}

	fmt.Println("Counting the connected items")
	sideA = countConnected(vertices[0], map[*Vertex]bool{})
	sideB = len(graph) - sideA

	// return the product
	result = sideA * sideB
	return strconv.Itoa(result)
}

func walkPath(path []*Vertex) {
	for i := 0; i < len(path)-1; i++ {
		a, b := path[i], path[i+1]
		edgeAB := a.edges[slices.IndexFunc(a.edges, func(edge *Edge) bool {
			return edge.a == b || edge.b == b
		})]
		edgeAB.weight += 1
	}
}

func (Solution) Part02(input string) string {
	lines := strings.Split(strings.TrimSpace(input), "\n")
	if len(lines) == 0 {
		return "NO DATA"
	}

	return "PENDING"
}
