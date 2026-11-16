package se.liu.elior637.components.assets;

import se.liu.elior637.coregame.Player;
import se.liu.elior637.components.tile.Resource;
import se.liu.elior637.coregame.logic.UnifiedPlacementRuleImplementation;

import java.util.Collections;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

/**
 * Enum for storing all building types. The enums store implementations classes of the enumtype and assigns a ruleimplementation.
 * Also stores cost.
 */
public enum BuildingType {
    SETTLEMENT(SettlementImplementation::new,
               new UnifiedPlacementRuleImplementation(),
               "Settlement",
               Map.of(
                       Resource.BRICK, 1,
                       Resource.LUMBER, 1,
                       Resource.GRAIN, 1,
                       Resource.WOOL, 1
               )
    ),
    CITY(CityImplementation::new,
         new UnifiedPlacementRuleImplementation(),
         "City",
         Map.of(
                 Resource.GRAIN,2,
                 Resource.ORE,3
         )
    );
    private final PlaceableHandler<Building> handler;
    private final PlacementRule placementRule;
    private final String displayName;
    private final Map<Resource, Integer> cost;

    BuildingType(
            Function<Player, Building> handler,
            PlacementRule placementRule,
            String displayName,
            Map<Resource, Integer> cost
    ){
        this.handler = handler::apply;
        this.placementRule = placementRule;
        this.displayName = displayName;
        this.cost = Collections.unmodifiableMap(new EnumMap<>(cost));
    }

    public PlaceableHandler<Building> getHandler() {
        return handler;
    }

    /**
     *
     * @return Placementrule for an enumtype
     */
    public PlacementRule getPlacementRule() {
        return placementRule;
    }

    public String getDisplayName() {
        return displayName;
    }

    /**
     * Returns the cost for a building.
     * @return
     */
    public Map<Resource, Integer> getCost() {
        return cost;
    }

    /**
     *
     * @return upgrades for enumtype. List of BuildingType is empty if there are no upgrades for a building.
     */
    public static Map<BuildingType, List<BuildingType>> getUpgradePaths() {
        Map<BuildingType, List<BuildingType>> upgradeMap = new EnumMap<>(BuildingType.class);
        upgradeMap.put(SETTLEMENT, List.of(CITY));
        upgradeMap.put(CITY, List.of());
        return Collections.unmodifiableMap(upgradeMap);
    }

}