///

import Foundation
import UIKit

final class LanguageSelectionViewController: UIViewController {
    enum Mode {
        case onboarding
        case settings
    }

    private let backgroundImageView = UIImageView()
    private let contentStackView = UIStackView()

    private let crownImagView = UIImageView()
    private let titleLabel = UILabel()
    private let continueButton = UIButton()

    private let languagesStackView = UIStackView()
    private let languagesScrollView = UIScrollView()

    private var selectedLanguage: Languages = Languages.current
    private let mode: Mode

    init(mode: Mode = .onboarding) {
        self.mode = mode

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupComponents()
        setupConstraints()
    }

    // MARK: Interface

    // MARK: Private

    private func setupComponents() {
        backgroundImageView.image = UIImage(named: "orange-background")
        backgroundImageView.contentMode = .scaleAspectFill

        crownImagView.image = UIImage(named: "crown")
        crownImagView.contentMode = .scaleAspectFit

        titleLabel.font = NSLabelType.latoBlackItalic(size: 34.0).font
        titleLabel.textColor = .white
        titleLabel.text = "language_selection_title".ub_localized
        titleLabel.textAlignment = .center
        titleLabel.accessibilityLanguage = Languages.current.languageCode
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true

        let continueButtonTitle = mode == .onboarding ? "language_selection_continue_button_title".ub_localized : "language_selection_save_button_title".ub_localized
        continueButton.setTitle(continueButtonTitle, for: .normal)
        continueButton.titleLabel?.font = NSLabelType.headline.font
        continueButton.layer.borderWidth = 2.0
        continueButton.addTarget(self, action: #selector(didTapOnContinue), for: .touchUpInside)
        continueButton.accessibilityLanguage = Languages.current.languageCode
        setContinueButton(enabled: false)

        languagesStackView.axis = .vertical
        languagesStackView.distribution = .equalSpacing
        languagesStackView.alignment = .fill
        languagesStackView.spacing = 8.0
        loadLanguageButtons()

        if mode == .settings {
            preselectLanguageButton()
        }

        contentStackView.axis = .vertical
        contentStackView.distribution = .fill
        contentStackView.alignment = .center
        [crownImagView, titleLabel, languagesScrollView].forEach(contentStackView.addArrangedSubview(_:))
        contentStackView.setCustomSpacing(22.0, after: crownImagView)
        contentStackView.setCustomSpacing(8.0, after: titleLabel)

        languagesScrollView.addSubview(languagesStackView)

        [backgroundImageView, contentStackView, continueButton].forEach(view.addSubview(_:))
    }

    private func setupConstraints() {
        [backgroundImageView, contentStackView, continueButton, languagesScrollView, languagesStackView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60.0),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            view.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: 32.0),

            continueButton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 20.0),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 40.0),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            view.trailingAnchor.constraint(equalTo: continueButton.trailingAnchor, constant: 32.0),
            continueButton.heightAnchor.constraint(equalToConstant: 52.0),

            languagesScrollView.topAnchor.constraint(equalTo: languagesStackView.topAnchor),
            languagesScrollView.leadingAnchor.constraint(equalTo: languagesStackView.leadingAnchor),
            languagesStackView.trailingAnchor.constraint(equalTo: languagesScrollView.trailingAnchor),
            languagesStackView.bottomAnchor.constraint(equalTo: languagesScrollView.bottomAnchor),
            languagesScrollView.widthAnchor.constraint(equalTo: languagesStackView.widthAnchor, multiplier: 1.0),
            languagesScrollView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 1.0),
        ])
    }

    private func loadLanguageButtons() {
        Languages.allCases.map { (language) -> UIButton in
            let button = SelectableButton()
            button.rightIconImage = UIImage(named: "tick")
            button.setTitle(language.name, for: .normal)
            button.layer.borderColor = UIColor.white.cgColor
            button.titleLabel?.font = NSLabelType.headline.font
            button.addTarget(self, action: #selector(didSelectLanguageOption(_:)), for: .touchUpInside)
            button.accessibilityLanguage = language.languageCode
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 52).isActive = true

            return button
        }
        .forEach(languagesStackView.addArrangedSubview(_:))
    }

    private func preselectLanguageButton() {
        guard let index = Languages.allCases.firstIndex(of: selectedLanguage),
            let button = languagesStackView.arrangedSubviews[index] as? SelectableButton else { return }

        didSelectLanguageOption(button)
    }

    private func setContinueButton(enabled: Bool) {
        let alpha: CGFloat = enabled ? 1.0 : 0.4
        continueButton.setTitleColor(UIColor.white.withAlphaComponent(alpha), for: .normal)
        continueButton.layer.borderColor = UIColor.white.withAlphaComponent(alpha).cgColor
        continueButton.isEnabled = enabled
    }

    // MARK: Actions

    @objc private func didSelectLanguageOption(_ button: SelectableButton) {
        languagesStackView.arrangedSubviews.forEach {
            $0.layer.borderWidth = 0
            ($0 as? SelectableButton)?.isRightIconHidden = true
        }

        button.layer.borderWidth = 2.0
        button.isRightIconHidden = false

        if let buttonIndex = languagesStackView.arrangedSubviews.firstIndex(of: button) {
            selectedLanguage = Languages.allCases[buttonIndex]
        }

        setContinueButton(enabled: true)
    }

    @objc private func didTapOnContinue() {
        Languages.setNewDefaultLanguage(to: selectedLanguage)

        if mode == .onboarding {
            goToDashboard()
        } else {
            reloadDashboard()
        }
    }

    private func reloadDashboard(animated _: Bool = true) {
        let transition = CATransition()
        transition.duration = CFTimeInterval(0.5)
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        UIApplication.shared.keyWindow?.layer.add(transition, forKey: nil)
        let navigationController = UINavigationController(rootViewController: NSHomescreenViewController())
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }

    private func goToDashboard(animated _: Bool = true) {
        let transition = CATransition()
        transition.duration = CFTimeInterval(0.5)
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        UIApplication.shared.keyWindow?.layer.add(transition, forKey: nil)
        UIApplication.shared.keyWindow?.rootViewController = OnboardingViewController()
    }
}
