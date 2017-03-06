
shared class DwellingType {
    String name;
    shared new apartment { name = "Apartment"; }
    shared new flat { name = "Flat"; }
    shared new house { name = "House"; }
    string => "DwellingType: ``name``";
}

shared interface IDwelling {
    shared formal Integer rooms;
    shared formal Integer area;
}

shared interface IDwellingTypeKnown {
    shared formal DwellingType type;
}

shared alias IKnownDwelling => IDwelling&IDwellingTypeKnown;

shared DwellingType guessType({IKnownDwelling+} nodes, IDwelling unknown, Integer k = 3) {
    "k must be a positive integer"
    assert(k > 0);

    value closest = pickKClosest(k, nodes, unknown);
    return mostCommonType(closest);
}

// Private stuff

interface Ranges {
    shared formal Integer roomRange;
    shared formal Integer areaRange;
}

Float distanceBetween(Ranges ranges, IDwelling node1, IDwelling node2) {
    value deltaRooms = (node1.rooms - node2.rooms) / ranges.roomRange.float;
    value deltaArea = (node1.area - node2.area) / ranges.areaRange.float;
    return (deltaRooms * deltaRooms + deltaArea * deltaArea) ^ 0.5;
}

Ranges getRanges({IDwelling+} dwellings) {
    value allRooms = dwellings*.rooms;
    value allAreas = dwellings*.area;
    return object satisfies Ranges {
        shared actual Integer roomRange => max(allRooms) - min(allRooms);
        shared actual Integer areaRange => max(allAreas) - min(allAreas);
    };
}

{IDwellingTypeKnown+} pickKClosest(Integer k, {IKnownDwelling+} nodes, IDwelling unknown) {
    value ranges = getRanges([ unknown, *nodes ]);
    value sorted = nodes.sort(byIncreasing((IDwelling node) => distanceBetween(ranges, node, unknown)));
    value topK = [*sorted.take(k)]; // Convert to array
    assert (nonempty topK);
    return topK;
}

DwellingType mostCommonType({IDwellingTypeKnown+} nodes) {
    value types = nodes*.type;
    value mappings = types.frequencies();
    value max = mappings.max((x, y) => x.item <=> y.item);
    assert (exists max); // We know it's a non-empty map
    return max.key;
}

