//
//  CountryballFacts.swift
//  CountryballDrop
//

import Foundation

struct CountryballFact {
    let id: String
    let capital: String
    /// Commonly cited national or signature dish — countries vary in having one “official” plate.
    let nationalDish: String
    let funFact: String

    var displayTitle: String {
        UnlockedCountryballsStore.displayTitle(for: id)
    }
}

enum CountryballFacts {

    static func info(for id: String) -> CountryballFact? {
        switch id {
        case "vatican":
            return CountryballFact(
                id: id,
                capital: "Vatican City",
                nationalDish: "Roman classics like cacio e pepe (no single official national dish)",
                funFact: "The Vatican is the world’s smallest independent state and fits inside Rome."
            )
        case "luxembourg":
            return CountryballFact(
                id: id,
                capital: "Luxembourg City",
                nationalDish: "Judd mat Gaardebounen (smoked pork with broad beans)",
                funFact: "Luxembourg is the world’s only remaining Grand Duchy."
            )
        case "netherlands":
            return CountryballFact(
                id: id,
                capital: "Amsterdam",
                nationalDish: "Stroopwafel (caramel waffle cookies)",
                funFact: "Roughly a third of the Netherlands lies below sea level, protected by dikes and pumps."
            )
        case "ireland":
            return CountryballFact(
                id: id,
                capital: "Dublin",
                nationalDish: "Irish stew",
                funFact: "Ireland is nicknamed the Emerald Isle for its green countryside after rain."
            )
        case "uk":
            return CountryballFact(
                id: id,
                capital: "London",
                nationalDish: "Fish and chips",
                funFact: "The UK includes England, Scotland, Wales, and Northern Ireland."
            )
        case "poland":
            return CountryballFact(
                id: id,
                capital: "Warsaw",
                nationalDish: "Pierogi (filled dumplings)",
                funFact: "Poland celebrates Fat Thursday with heaps of jam-filled donuts called pączki."
            )
        case "germany":
            return CountryballFact(
                id: id,
                capital: "Berlin",
                nationalDish: "Sauerbraten (marinated pot roast)",
                funFact: "Germany’s first Oktoberfest was a royal wedding party in Munich in 1810."
            )
        case "ukraine":
            return CountryballFact(
                id: id,
                capital: "Kyiv",
                nationalDish: "Borscht (beet soup)",
                funFact: "Sunflower seeds are such a staple that Ukraine leads the world in sunflower oil exports."
            )
        case "russia":
            return CountryballFact(
                id: id,
                capital: "Moscow",
                nationalDish: "Pelmeni (meat dumplings)",
                funFact: "Russia spans eleven time zones—more than any other country."
            )
        default:
            return nil
        }
    }
}
