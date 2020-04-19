///

import Foundation
import UIKit

final class OnboardingStepViewController: UIViewController, OnboardingView {
    let identifier: OnboardingStep
    weak var delegate: OnboardingViewDelegate?

    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let imageContainer = UIView()

    private let backgroundImageView = UIImageView()
    private let foregorundImageView = UIImageView()

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    init(identifier: OnboardingStep) {
        self.identifier = identifier

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Not in use")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupComponents()
        setupConstraints()
    }

    // MARK: Interface

    var hasRequiredPermission: Bool {
        return true
    }

    var canContinue: Bool {
        return true
    }

    func setup(with model: OnboardingStepModel) {
        backgroundImageView.image = model.backgroundImage
        foregorundImageView.image = model.foregroundImage
        titleLabel.text = model.title
        messageLabel.text = model.message
    }

    // MARK: Private

    private func setupComponents() {
        titleLabel.textColor = UIColor.ns_black
        titleLabel.font = NSLabelType.title.font
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center

        messageLabel.textColor = UIColor.ns_black?.withAlphaComponent(0.7)
        messageLabel.font = NSLabelType.text.font
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.alpha = 0.3

        foregorundImageView.contentMode = .scaleAspectFit

        imageContainer.backgroundColor = .clear
        [backgroundImageView, foregorundImageView].forEach(imageContainer.addSubview(_:))

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        [titleLabel, messageLabel, imageContainer].forEach(stackView.addArrangedSubview(_:))
        stackView.setCustomSpacing(24, after: titleLabel)
        stackView.setCustomSpacing(24, after: messageLabel)

        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.addSubview(stackView)

        view.addSubview(scrollView)
    }

    private func setupConstraints() {
        [scrollView, stackView, imageContainer, backgroundImageView, foregorundImageView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            foregorundImageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            foregorundImageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: foregorundImageView.trailingAnchor),
            imageContainer.bottomAnchor.constraint(equalTo: foregorundImageView.bottomAnchor),

            backgroundImageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            imageContainer.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),

            scrollView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 32.0),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
}
