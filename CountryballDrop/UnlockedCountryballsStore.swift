//
//  UnlockedCountryballsStore.swift
//  CountryballDrop
//

import Foundation

enum UnlockedCountryballsStore {

    /// European tier balls used for merges and carousel prizes (`world` is not a collectible prize).
    static let europeanIds: [String] = ["vatican", "luxembourg", "netherlands", "ireland", "uk",
                                         "poland", "germany", "ukraine", "russia"]

    private static let userDefaultsKey = "unlockedCountryballIds"

    static func unlockedIds() -> Set<String> {
        guard let arr = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] else {
            return []
        }
        return Set(arr)
    }

    static func unlock(_ id: String) {
        guard europeanIds.contains(id) else { return }
        var set = unlockedIds()
        guard !set.contains(id) else { return }
        set.insert(id)
        UserDefaults.standard.set(Array(set).sorted(), forKey: userDefaultsKey)
    }

    static func isUnlocked(_ id: String) -> Bool {
        unlockedIds().contains(id)
    }

    static func displayTitle(for id: String) -> String {
        switch id {
        case "uk": return "UK"
        case "vatican": return "Vatican City"
        default: return id.capitalized
        }
    }
}
