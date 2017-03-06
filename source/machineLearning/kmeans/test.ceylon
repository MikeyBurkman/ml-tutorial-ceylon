
    shared void testKmeans() {
        value data = getTestData();

        value centers = findClusterPoints(3, data);

        print("Running...");
        print("Centers: ``centers``");

        // Should result in something like
        // Centers: [[1.7142857142857142, 2.0], [7.5, 2.6666666666666665], [8.333333333333334, 9.0]]

    }

    Point[] getTestData() {
        return [
            [1.0, 2.0],
            [2.0, 1.0],
            [2.0, 4.0],
            [1.0, 3.0],
            [2.0, 2.0],
            [3.0, 1.0],
            [1.0, 1.0],
            [7.0, 3.0],
            [8.0, 2.0],
            [6.0, 4.0],
            [7.0, 4.0],
            [8.0, 1.0],
            [9.0, 2.0],
            [10.0, 8.0],
            [9.0, 10.0],
            [7.0, 8.0],
            [7.0, 9.0],
            [8.0, 10.0],
            [9.0, 9.0]
        ];
    }