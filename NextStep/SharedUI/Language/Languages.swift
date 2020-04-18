///

import Foundation

enum Languages {
    case nederlandse
    case english
    case spanish

    var title: String {
        switch self {
        case .nederlandse: return "Nederlandse"
        case .english: return "English"
        case .spanish: return "Spanish"
        }
    }
}
