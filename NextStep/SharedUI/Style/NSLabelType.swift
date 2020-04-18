/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

public enum NSLabelType: UBLabelType, Equatable {
    case title
    case subtitle
    case text
    case textSemiBold
    case button // used for button
    case smallBold // used for begegnungen label
    case uppercaseBold
    case headline
    case latoLightItalic(size: CGFloat)
    case latoRegular(size: CGFloat)

    public var font: UIFont {
        switch self {
        case .title: return UIFont(name: "Lato-BlackItalic", size: 36.0)!
        case .subtitle: return UIFont(name: "Lato-Bold", size: 16.0)!
        case .text: return UIFont(name: "Lato-Medium", size: 16.0)!
        case .smallBold: return UIFont(name: "Lato-Bold", size: 12.0)!
        case .textSemiBold: return UIFont(name: "Lato-Bold", size: 16.0)!
        case .button: return UIFont(name: "Lato-Bold", size: 16.0)!
        case .uppercaseBold: return UIFont(name: "Lato-Bold", size: 16.0)!
        case .headline: return UIFont(name: "Lato-Bold", size: 22.0)!

        case let .latoRegular(size): return UIFont(name: "Lato-Regular", size: size)!
        case let .latoLightItalic(size): return UIFont(name: "Lato-LightItalic", size: size)!
        }
    }

    public var textColor: UIColor {
        switch self {
        case .title:
            return .ns_primary
        case .button:
            return .white
        default:
            return .ns_text
        }
    }

    public var lineSpacing: CGFloat {
        switch self {
        case .title: return 34.0 / 28.0
        case .subtitle: return 31.0 / 24.0
        case .text: return 24.0 / 16.0
        case .textSemiBold: return 24.0 / 16.0
        case .button, .smallBold: return 1.0
        case .uppercaseBold: return 26.0 / 16.0
        case .headline: return 28.0 / 16.0
        case .latoLightItalic: return 28
        case .latoRegular: return 28
        }
    }

    public var letterSpacing: CGFloat? {
        if self == .uppercaseBold {
            return 1.0
        }

        return nil
    }

    public var isUppercased: Bool {
        if self == .uppercaseBold {
            return true
        }

        return false
    }

    public var hyphenationFactor: Float {
        return 1.0
    }

    public var lineBreakMode: NSLineBreakMode {
        return .byTruncatingTail
    }

    public static func == (lhs: NSLabelType, rhs: NSLabelType) -> Bool {
        switch (lhs, rhs) {
        case (.title, .title): return true
        case (.subtitle, .subtitle): return true
        case (.text, .text): return true
        case (.textSemiBold, .textSemiBold): return true
        case (.button, .button): return true
        case (.smallBold, .smallBold): return true
        case (.uppercaseBold, .uppercaseBold): return true
        case let (.latoLightItalic(lhsS), .latoLightItalic(rhsS)): return lhsS == rhsS
        case let (.latoRegular(lhsS), .latoRegular(rhsS)): return lhsS == rhsS
        default: return false
        }
    }
}

class NSLabel: UBLabel<NSLabelType> {}
