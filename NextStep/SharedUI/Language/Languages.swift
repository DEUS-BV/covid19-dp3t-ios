///

import Foundation

enum Languages: String, CaseIterable {
    private static let defaultLanguageKey = "defaultLanguageKey"

    case dutch
    case english

    static func setNewDefaultLanguage(to newLangugage: Languages) {
        defaultLanguage = newLangugage

        // RELOAD UI
    }

    var name: String {
        switch self {
        case .dutch: return "Nederlands"
        case .english: return "English"
        }
    }

    static var current: Languages {
        return defaultLanguage
    }

    var languageCode: String {
        return preferredLocale.languageCode ?? "nl"
    }

    var preferredLocale: Locale {
        switch self {
        case .dutch:
            return Locale(identifier: "nl-NL")

        case .english:
            return Locale(identifier: "en-US")
        }
    }

    private static var defaultLanguage: Languages {
        get {
            guard let storedDefaultValue = UserDefaults.standard.string(forKey: Languages.defaultLanguageKey),
                let defaultLanguage = Languages(rawValue: storedDefaultValue) else {
                UserDefaults.standard.set(Languages.dutch.rawValue, forKey: Languages.defaultLanguageKey)
                UserDefaults.standard.synchronize()
                return .dutch
            }

            return defaultLanguage
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Languages.defaultLanguageKey)
            UserDefaults.standard.synchronize()
        }
    }
}
