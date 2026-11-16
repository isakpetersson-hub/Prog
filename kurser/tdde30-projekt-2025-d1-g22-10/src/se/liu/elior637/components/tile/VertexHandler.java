package se.liu.elior637.components.tile;

import se.liu.elior637.coregame.Board;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Class to handle vertices.
 * The class is mainly used to get and create vertices, to ensure overlapping vertices are treated as the same object.
 * Use: VertexHandler.getInstance() to ensure proper function.
 */
public class VertexHandler {
    private final Map<String, Vertex> vertexMap = new HashMap<>();

    public VertexHandler() {}

    public Vertex getOrCreateVertex(Hex hex, int direction) {
        String canonicalKey = getCanonicalVertexKey(hex,direction);
        return vertexMap.computeIfAbsent(canonicalKey,k -> new Vertex(hex,direction));
    }

    public Vertex getVertex(Hex hex, int direction) {
        String canonicalKey = getCanonicalVertexKey(hex,direction);
        return vertexMap.get(canonicalKey);
    }

    private String getCanonicalVertexKey(Hex hex, int direction) {
        int q = hex.getQCoordinate();
        int r = hex.getRCoordinate();
        return switch (direction) {
            case 0 -> canonical(q, r, 0, q, r - 1, 2, q + 1, r - 1, 4);
            case 1 -> canonical(q, r, 1, q + 1, r - 1, 3, q + 1, r, 5);
            case 2 -> canonical(q, r + 1, 0, q + 1, r, 4, q, r, 2);
            case 3 -> canonical(q, r, 3, q, r + 1, 5, q - 1, r + 1, 1);
            case 4 -> canonical(q - 1, r + 1, 0, q - 1, r, 2, q, r, 4);
            case 5 -> canonical(q - 1, r, 1, q, r - 1, 3, q, r, 5);
            default -> throw new IllegalStateException("Unexpected direction: " + direction);
        };
    }

    private String canonical(int q1, int r1, int d1, int q2, int r2, int d2, int q3, int r3, int d3) {
        String s1 = "h" + q1 + "," + r1 + "v" + d1;
        String s2 = "h" + q2 + "," + r2 + "v" + d2;
        String s3 = "h" + q3 + "," + r3 + "v" + d3;
        return Stream.of(s1, s2, s3).min(String::compareTo).orElse(s1);
    }

    public List<Vertex> getAdjacentVertices(Vertex vertex, Board board) {
        List<Vertex> adjacent = new ArrayList<>();

        for (ResourceTile resourceTile : board.getTiles().values()) {
            Hex hex = resourceTile.getPosition();
            Map<Integer, Vertex> vertexMap = board.getTileVertices(hex);
            if (vertexMap == null) continue;

            for (int dir = 0; dir < 6; dir++) {
                if (vertex.equals(vertexMap.get(dir))) {
                    int q = hex.getQCoordinate();
                    int r = hex.getRCoordinate();
                    switch (dir) {
                        case 0: // Top
                            adjacent.add(getVertex(hex, 1)); // v1
                            adjacent.add(getVertex(hex, 5)); // v5
                            adjacent.add(getVertex(new Hex(q, r - 1), 2)); // v2 of (q, r-1)
                            adjacent.add(getVertex(new Hex(q + 1, r - 1), 4)); // v4 of (q+1, r-1)
                            break;
                        case 1: // Top-right
                            adjacent.add(getVertex(hex, 0)); // v0
                            adjacent.add(getVertex(hex, 2)); // v2
                            adjacent.add(getVertex(new Hex(q + 1, r - 1), 3)); // v3 of (q+1, r-1)
                            adjacent.add(getVertex(new Hex(q + 1, r), 5)); // v5 of (q+1, r)
                            break;
                        case 2: // Bottom-right
                            adjacent.add(getVertex(hex, 1)); // v1
                            adjacent.add(getVertex(hex, 3)); // v3
                            adjacent.add(getVertex(new Hex(q + 1, r), 4)); // v4 of (q+1, r)
                            adjacent.add(getVertex(new Hex(q, r + 1), 0)); // v0 of (q, r+1)
                            break;
                        case 3: // Bottom
                            adjacent.add(getVertex(hex, 2)); // v2
                            adjacent.add(getVertex(hex, 4)); // v4
                            adjacent.add(getVertex(new Hex(q, r + 1), 5)); // v5 of (q, r+1)
                            adjacent.add(getVertex(new Hex(q - 1, r + 1), 1)); // v1 of (q-1, r+1)
                            break;
                        case 4: // Bottom-left
                            adjacent.add(getVertex(hex, 3)); // v3
                            adjacent.add(getVertex(hex, 5)); // v5
                            adjacent.add(getVertex(new Hex(q - 1, r + 1), 0)); // v0 of (q-1, r+1)
                            adjacent.add(getVertex(new Hex(q - 1, r), 2)); // v2 of (q-1, r)
                            break;
                        case 5: // Top-left
                            adjacent.add(getVertex(hex, 4)); // v4
                            adjacent.add(getVertex(hex, 0)); // v0
                            adjacent.add(getVertex(new Hex(q - 1, r), 1)); // v1 of (q-1, r)
                            adjacent.add(getVertex(new Hex(q, r - 1), 3)); // v3 of (q, r-1)
                            break;
                        default:
                            throw new IllegalStateException("Unexpected direction: " + dir);
                    }
                }
            }
        }
        return adjacent.stream().filter(Objects::nonNull).collect(Collectors.toList());
    }

}
