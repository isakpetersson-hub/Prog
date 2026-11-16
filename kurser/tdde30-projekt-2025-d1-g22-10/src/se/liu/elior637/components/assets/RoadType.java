package se.liu.elior637.components.assets;

import se.liu.elior637.coregame.Player;
import se.liu.elior637.components.tile.Resource;
import se.liu.elior637.coregame.logic.UnifiedPlacementRuleImplementation;

import java.util.Collections;
import java.util.EnumMap;
import java.util.Map;
import java.util.function.Function;

/**
 * Enum for storing all road types. The enums store implementations classes of the enumtype and assigns a ruleimplementation.
 * Also stores cost.
 * Is a singelton beacuse there is only one type of road but his is done because if expansions are added this simplifys the process
 */
public enum RoadType {
    STANDARD_ROAD(StandardRoadImplementation::new,
                  new UnifiedPlacementRuleImplementation(),
                  "Road",
                  Map.of(
                          Resource.LUMBER, 1,
                          Resource.BRICK, 1
                  )
    );

    private final PlaceableHandler<Road> handler;
    private final PlacementRule placementRule;
    private final String displayName;
    private final Map<Resource, Integer> cost;

    RoadType(
            Function<Player, Road> handler,
            PlacementRule placementRule,
            String displayName,
            Map<Resource, Integer> cost
    ) {
        this.handler = handler::apply;
        this.placementRule = placementRule;
        this.displayName = displayName;
        this.cost = Collections.unmodifiableMap(new EnumMap<> (cost));
    }

    /**
     * Get handler for the enumType.
     * @return PlaceableHandler for Road.
     */
    public PlaceableHandler<Road> getHandler() {
        return handler;
    }

    /**
     * Get placement rule for the enumType
     * @return Placement rule
     */
    public PlacementRule getPlacementRule() {
        return placementRule;
    }

    /**
     * Get displayname for enumType
     * @return String Displayname for the Road enumType
     */
    public String getDisplayName() {
        return displayName;
    }

    /**
     * Get cost for an enumType
     * @return Map with resources and amount
     */
    public Map<Resource, Integer> getCost() {
        return cost;
    }
}