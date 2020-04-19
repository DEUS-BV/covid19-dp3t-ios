///

import UIKit.UIImage

enum RequiredPermission: String, CaseIterable {
    case bluetooth
    case notifications

    var model: PermissionButtonModel {
        switch self {
        case .bluetooth:
            return PermissionButtonModel(identifier: rawValue, icon: UIImage(named: "bluetooth-icon"), rightIcon: UIImage(named: "check-mark"), title: "permission_step_one".ub_localized, permissionName: "permission_bluetooth_name".ub_localized)

        case .notifications:
            return PermissionButtonModel(identifier: rawValue, icon: UIImage(named: "push-notifications-icon"), rightIcon: UIImage(named: "check-mark"), title: "permission_step_two".ub_localized, permissionName: "permission_notifications_name".ub_localized)
        }
    }
}
