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
    case smallText
    case button // used for button
    case smallBold // used for begegnungen label
    case uppercaseBold
    case headline
    case headerTitle
    case latoLightItalic(size: CGFloat)
    case latoRegular(size: CGFloat)
    case latoBlackItalic(size: CGFloat)

    public var font: UIFont {
        switch self {
        case .title: return scaledFont(UIFont(name: "Lato-BlackItalic", size: 36.0)!)
        case .subtitle: return scaledFont(UIFont(name: "Lato-Bold", size: 16.0)!)
        case .text: return scaledFont(UIFont(name: "Lato-Medium", size: 16.0)!)
        case .smallBold: return scaledFont(UIFont(name: "Lato-Bold", size: 12.0)!)
        case .textSemiBold: return scaledFont(UIFont(name: "Lato-Bold", size: 16.0)!)
        case .smallText: return scaledFont(UIFont(name: "Lato-Medium", size: 14.0)!)
        case .button: return scaledFont(UIFont(name: "Lato-Bold", size: 16.0)!)
        case .uppercaseBold: return scaledFont(UIFont(name: "Lato-Bold", size: 16.0)!)
        case .headline: return scaledFont(UIFont(name: "Lato-Bold", size: 22.0)!)
        case .headerTitle: return scaledFont(UIFont(name: "Lato-BlackItalic", size: 20.0)!)

        case let .latoRegular(size): return scaledFont(UIFont(name: "Lato-Regular", size: size)!)
        case let .latoLightItalic(size): return scaledFont(UIFont(name: "Lato-LightItalic", size: size)!)
        case let .latoBlackItalic(size): return scaledFont(UIFont(name: "Lato-BlackItalic", size: size)!)
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
        case .button, .smallBold, .headerTitle: return 1.0
        case .uppercaseBold: return 26.0 / 16.0
        case .headline: return 28.0 / 16.0
        case .smallText: return 28.0 / 16.0
        case .latoLightItalic: return 28
        case .latoRegular: return 28
        case .latoBlackItalic: return 28
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
        case (.headerTitle, .headerTitle): return true
        case (.smallText, .smallText): return true
        case let (.latoLightItalic(lhsS), .latoLightItalic(rhsS)): return lhsS == rhsS
        case let (.latoRegular(lhsS), .latoRegular(rhsS)): return lhsS == rhsS
        case let (.latoBlackItalic(lhsS), .latoBlackItalic(rhsS)): return lhsS == rhsS
        default: return false
        }
    }

    // MARK: - Private

    private func scaledFont(_ font: UIFont) -> UIFont {
        UIFontMetrics.default.scaledFont(for: font)
    }
}

class NSLabel: UBLabel<NSLabelType> {}
