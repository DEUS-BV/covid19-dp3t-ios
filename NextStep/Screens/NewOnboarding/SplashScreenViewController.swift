///

import Foundation
import UIKit

final class SplashScreenViewController: UIViewController {
    private let backgroundImageView = UIImageView()
    private let crownImageView = UIImageView()
    private let logoImageView = UIImageView()
    private let netherlandsImageView = UIImageView()
    private let sloganLabel = UILabel()
    private let messageLabel = UILabel()

    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupComponents()
        setupConstraints()
    }

    // MARK: Interface

    // MARK: Private

    private func setupComponents() {
        backgroundImageView.image = UIImage(named: "orange-background")

        crownImageView.image = UIImage(named: "crown")
        crownImageView.contentMode = .scaleAspectFit

        logoImageView.image = UIImage(named: "app-name")
        logoImageView.contentMode = .scaleAspectFit

        netherlandsImageView.image = UIImage(named: "netherlands-image")
        netherlandsImageView.contentMode = .scaleAspectFit

        sloganLabel.text = "splash_slogan".ub_localized
        sloganLabel.font = NSLabelType.latoLightItalic(size: 26).font
        sloganLabel.textColor = UIColor.white.withAlphaComponent(0.45)

        messageLabel.text = "splash_message".ub_localized
        messageLabel.font = NSLabelType.latoRegular(size: 18).font
        messageLabel.textColor = UIColor.white.withAlphaComponent(0.45)

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        [crownImageView, logoImageView, sloganLabel,
         netherlandsImageView, messageLabel].forEach(stackView.addArrangedSubview(_:))

        stackView.setCustomSpacing(16, after: crownImageView)
        stackView.setCustomSpacing(12, after: sloganLabel)
        stackView.setCustomSpacing(22, after: netherlandsImageView)

        [backgroundImageView, stackView].forEach(view.addSubview(_:))
    }

    private func setupConstraints() {
        [backgroundImageView, stackView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),

            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
