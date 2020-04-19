///

import Foundation
import UIKit

enum OnboardingStep: CaseIterable {
    case privacy
    case informed
    case setup

    var viewController: UIViewController & OnboardingView {
        switch self {
        case .privacy:
            return OnboardingStepViewController(identifier: self)

        case .informed:
            return OnboardingStepViewController(identifier: self)

        case .setup:
            return OnboardingPermissionStepViewController(identifier: self)
        }
    }

    var position: Int {
        return OnboardingStep.allCases.firstIndex(of: self) ?? -1
    }

    var model: OnboardingStepModel {
        switch self {
        case .privacy:
            return OnboardingStepModel(foregroundImage: UIImage(named: "onboarding-frgnd-step-1"),
                                       backgroundImage: UIImage(named: "onboarding-bcgnd-step-1"),
                                       title: "onboarding_step_one_title".ub_localized,
                                       message: "onboarding_step_one_message".ub_localized)

        case .informed:
            return OnboardingStepModel(foregroundImage: UIImage(named: "onboarding-frgnd-step-2"),
                                       backgroundImage: UIImage(named: "onboarding-bcgnd-step-2"),
                                       title: "onboarding_step_two_title".ub_localized,
                                       message: "onboarding_step_two_message".ub_localized)

        case .setup:
            return OnboardingStepModel(foregroundImage: nil,
                                       backgroundImage: nil,
                                       title: "onboarding_step_permission_title".ub_localized,
                                       message: "onboarding_step_permission_message".ub_localized)
        }
    }
}

protocol OnboardingView: AnyObject {
    var delegate: OnboardingViewDelegate? { get set }
    var identifier: OnboardingStep { get }
    var canContinue: Bool { get }
    var hasRequiredPermission: Bool { get }

    func setup(with model: OnboardingStepModel)
}

protocol OnboardingViewDelegate: AnyObject {
    func stepDidUpdateContinueState(_ step: OnboardingView)
}
