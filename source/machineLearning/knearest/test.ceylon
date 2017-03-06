
shared void test() {
    class Unknown(rooms, area) satisfies IDwelling {
        shared actual Integer rooms;
        shared actual Integer area;
    }
    value testData = getTestData();

    print("Running...");

    assert (guessType(testData, Unknown(3, 350)) == DwellingType.apartment);
    assert (guessType(testData, Unknown(3, 1200)) == DwellingType.flat);
    assert (guessType(testData, Unknown(7, 1400)) == DwellingType.house);

    print("Finished alright");
}

{IKnownDwelling+} getTestData() {
    class Known(rooms, area, type) satisfies IDwelling&IDwellingTypeKnown {
        shared actual Integer rooms;
        shared actual Integer area;
        shared actual DwellingType type;
        string => "rooms: ``rooms``; area: ``area``; type: ``type``";
    }

    return {
        Known(1, 350, DwellingType.apartment),
        Known(2, 300, DwellingType.apartment),
        Known(3, 300, DwellingType.apartment),
        Known(4, 250, DwellingType.apartment),
        Known(4, 500, DwellingType.apartment),
        Known(4, 400, DwellingType.apartment),
        Known(5, 450, DwellingType.apartment),

        Known(7, 850, DwellingType.house),
        Known(7, 900, DwellingType.house),
        Known(7, 1200, DwellingType.house),
        Known(8, 1500, DwellingType.house),
        Known(8, 1240, DwellingType.house),
        Known(9, 1300, DwellingType.house),
        Known(9, 1000, DwellingType.house),
        Known(10, 1700, DwellingType.house),

        Known(1, 800, DwellingType.flat),
        Known(1, 900, DwellingType.flat),
        Known(1, 1000, DwellingType.flat),
        Known(1, 1300, DwellingType.flat),
        Known(2, 700, DwellingType.flat),
        Known(2, 1150, DwellingType.flat),
        Known(2, 1200, DwellingType.flat),
        Known(3, 900, DwellingType.flat)
    };
}