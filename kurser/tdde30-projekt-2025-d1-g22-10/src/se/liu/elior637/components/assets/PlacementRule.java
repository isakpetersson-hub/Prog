package se.liu.elior637.components.assets;

import se.liu.elior637.coregame.Board;
import se.liu.elior637.components.tile.Edge;
import se.liu.elior637.components.tile.Vertex;

import java.util.List;

/**
 * Core interface for game logic validation for buildings and roads.
 */
public interface PlacementRule
{
    List<Vertex> validateBuildingVertices(Board board, BuildingType buildingType);

    List<Edge> validateRoadEdges(Board board);
}
