install.packages('igraph', 'visNetwork', 'RNeo4j')
library(igraph)
library(visNetwork)
library(RNeo4j)


graph = startGraph("http://127.0.0.1:7474/db/data/",username="neo4j", password="password)

importSample(graph, "movies", input=F)

query = "
MATCH (p1:Person)-[:ACTED_IN]->(:Movie)<-[:ACTED_IN]-(p2:Person)
WHERE p1.name < p2.name
RETURN p1.name AS from, p2.name AS to, COUNT(*) AS weight
"

edges = cypher(graph, query)

head(edges)

nodes = data.frame(id=unique(c(edges$from, edges$to)))
nodes$label = nodes$id

# Now let’s bring igraph into play. igraph is a graph algorithms library, and we can easily create an igraph graph object to hold our subgraph by passing in the edgelist.

ig = graph_from_data_frame(edges, directed=F)
