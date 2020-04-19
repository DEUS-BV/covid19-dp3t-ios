/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

extension String {
    var ub_localized: String {
        let tableName = "Localizable"

        let path = Bundle.main.path(forResource: tableName, ofType: "strings", inDirectory: nil, forLocalization: Languages.current.languageCode)!
        let localBundle = Bundle(path: URL(fileURLWithPath: path).deletingLastPathComponent().relativePath)!
        return NSLocalizedString(self, tableName: tableName, bundle: localBundle, value: self, comment: "")
    }
}
