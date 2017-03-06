
import ceylon.math.float { random, sqrt, sum }
import ceylon.collection { HashMap, unlinked }

shared alias Point => [Float, Float];
shared alias ClusterCenter => Point;

shared ClusterCenter[] findClusterPoints(Integer k, Point[] points) {
    value initialClusterCenters = (1..k).collect((_) => randomPoint());
    value found = refineClusters(points, initialClusterCenters);
    return found.sort(byIncreasing((ClusterCenter c) => c.string));
}

// Private stuff

alias Cluster => Point[];

Point randomPoint() {
    value max = 10;
    return [
        random() * max,
        random() * max
    ];
}

Float distanceBetween(Point p1, Point p2) {
    value deltaX = p1[0] - p2[0];
    value deltaY = p1[1] - p2[1];
    return sqrt(deltaX * deltaX + deltaY * deltaY);
}

// Returns the index of which cluster center this point is closest to
Point closestCluster(ClusterCenter[] clusterCenters, Point point) {
    value dists = clusterCenters.indexed.collect((idx -> p) => idx -> distanceBetween(point, p));

    value sorted = dists.sort(increasingItem);

    assert (exists first = sorted[0]);

    value clustersArray = [*clusterCenters];
    assert (exists cluster = clustersArray[first.key]);
    return cluster;
}

// Maps each point to the cluster center it's closest to.
// cluster center -> points in that cluster
Map<ClusterCenter, Cluster> groupPointsToClusters(Point[] points, ClusterCenter[] clusterCenters) {
    value ret = HashMap<Point, Cluster>(unlinked);

    for (center in clusterCenters) {
        // Set the default values
        ret[center] = [];
    }

    for (point in points) {
        value clusterCenter = closestCluster(clusterCenters, point);
        value currentPointsInCluster = ret[clusterCenter] else [];
        // Add this point to the list of points for this cluster
        ret[clusterCenter] = [point, *currentPointsInCluster];
    }

    return ret;
}

Point averagePoint(Cluster cluster) {
    value xs = cluster.map((p) => p[0]);
    value ys = cluster.map((p) => p[1]);
    value len = cluster.size;
    return [
        sum(xs) / len,
        sum(ys) / len
    ];
}

Boolean clusterCenterHasChanged(ClusterCenter c1, ClusterCenter c2) {
    value dist = distanceBetween(c1, c2);
    return dist.largerThan(0.001); // Approximately zero
}

ClusterCenter calculateNewCenter(Cluster cluster) {
    // If we get a cluster with no points assigned to it, pick a new
    //  random point, so it's not a permanently dead cluster
    return if (cluster.empty) then randomPoint() else averagePoint(cluster);
}

ClusterCenter[] refineClusters(Point[] points, ClusterCenter[] clusterCenters) {
    value clusterMap = groupPointsToClusters(points, clusterCenters);

    // Entries of oldClusterCenter -> newClusterCenter
    value newClusters = clusterMap.map((center->cluster) => center -> calculateNewCenter(cluster));

    value anyChanged = newClusters.any((oldCenter->newCenter) => clusterCenterHasChanged(oldCenter, newCenter));

    if (anyChanged) {
        return refineClusters(points, newClusters*.item);
    } else {
        return clusterCenters;
    }
}