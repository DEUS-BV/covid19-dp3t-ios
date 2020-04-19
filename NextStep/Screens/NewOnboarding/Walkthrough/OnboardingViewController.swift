///

import Foundation
import UIKit

final class OnboardingViewController: UIViewController {
    private let stepViewControllers: [UIViewController & OnboardingView] = {
        OnboardingStep.allCases.map { $0.viewController }
    }()

    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let continueButton = UBButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupComponents()
        setupConstraints()
        addStepViewControllers()
    }

    // MARK: Interface

    // MARK: Private

    private func setupComponents() {
        view.backgroundColor = .white

        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.isScrollEnabled = false

        pageControl.currentPageIndicatorTintColor = .ns_orange
        pageControl.pageIndicatorTintColor = .ns_gray
        pageControl.numberOfPages = stepViewControllers.count
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false

        continueButton.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
        continueButton.setTitleColor(UIColor.ns_light_gray.withAlphaComponent(0.7), for: .disabled)
        setContinueButton(asFinal: false)
        continueButton.addTarget(self, action: #selector(didTapOnContinue), for: .touchUpInside)

        [scrollView, pageControl, continueButton].forEach(view.addSubview(_:))
    }

    private func setupConstraints() {
        [pageControl, scrollView, continueButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor),

            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 60),

            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: continueButton.trailingAnchor, constant: 32),
            continueButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }

    private func addStepViewControllers() {
        stepViewControllers.enumerated().forEach { index, vc in
            var constraints: [NSLayoutConstraint] = []

            addChild(vc)
            scrollView.addSubview(vc.view)

            vc.delegate = self
            vc.view.translatesAutoresizingMaskIntoConstraints = false

            constraints.append(contentsOf: [
                vc.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
                vc.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                vc.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            ])

            if index == 0 {
                constraints.append(vc.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor))
            }

            if index == (stepViewControllers.count - 1) {
                constraints.append(scrollView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor))
            }

            if index > 0 {
                let previousStepView = stepViewControllers[index - 1].view!
                constraints.append(previousStepView.trailingAnchor.constraint(equalTo: vc.view.leadingAnchor))
            }

            NSLayoutConstraint.activate(constraints)
            vc.didMove(toParent: self)

            vc.setup(with: vc.identifier.model)
        }
    }

    // MARK: Actions

    @objc private func didTapOnContinue() {
        guard currentStep < stepViewControllers.count - 1 else {
            let stepView = stepViewControllers[currentStep]
            if stepView.hasRequiredPermission {
                dismissOnboarding()
            } else {
                dismissWithoutNecessaryPermissions()
            }

            return
        }

        let targetContentOffsetX = CGFloat(currentStep + 1) * scrollView.frame.width
        let offset = CGPoint(x: targetContentOffsetX, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }

    private func dismissOnboarding() {
        User.shared.hasCompletedOnboarding = true

        let transition = CATransition()
        transition.duration = CFTimeInterval(0.5)
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        UIApplication.shared.keyWindow?.layer.add(transition, forKey: nil)
        let navigationController = UINavigationController(rootViewController: NSHomescreenViewController())
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }

    private func dismissWithoutNecessaryPermissions() {
        let alert = UIAlertController(title: nil, message: "onboarding_continue_without_popup_text".ub_localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "onboarding_continue_without_popup_abort".ub_localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "onboarding_continue_without_popup_continue".ub_localized, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.dismissOnboarding()
        }))

        present(alert, animated: true, completion: nil)
    }

    // MARK: Continue Button Styles

    private func updateContinueButtonState() {
        let stepView = stepViewControllers[currentStep]

        continueButton.isEnabled = stepView.canContinue
        continueButton.layer.borderColor = continueButton.isEnabled ? UIColor.black.cgColor : UIColor.ns_lighter_gray.cgColor
    }

    private func setContinueButton(asFinal isFinal: Bool) {
        if isFinal {
            continueButton.layer.borderWidth = 2.0
            continueButton.setTitle("onboarding_done_button_title".ub_localized, for: .normal)
            continueButton.setTitleColor(.black, for: .normal)
            continueButton.setTitleColor(UIColor.ns_lighter_gray, for: .disabled)
        } else {
            continueButton.layer.borderWidth = 0.0
            continueButton.setTitle("onboarding_next_button_title".ub_localized, for: .normal)
        }
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    var currentStep: Int {
        Int(round(scrollView.contentOffset.x / scrollView.frame.width))
    }

    func scrollViewDidScroll(_: UIScrollView) {
        pageControl.currentPage = currentStep
    }

    func scrollViewDidEndScrollingAnimation(_: UIScrollView) {
        setContinueButton(asFinal: currentStep == stepViewControllers.count - 1)
        updateContinueButtonState()
    }
}

extension OnboardingViewController: OnboardingViewDelegate {
    func stepDidUpdateContinueState(_: OnboardingView) {
        updateContinueButtonState()
    }
}
