///

import UIKit

final class SelectableButton: UIButton {
    private let rightIconImageView = UIImageView()

    init() {
        super.init(frame: .zero)

        setupComponents()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Interface

    var rightIconImage: UIImage? {
        didSet {
            rightIconImageView.image = rightIconImage
        }
    }

    var isRightIconHidden: Bool = true {
        didSet {
            rightIconImageView.isHidden = isRightIconHidden
        }
    }

    // MARK: Private

    private func setupComponents() {
        rightIconImageView.contentMode = .scaleAspectFit
        rightIconImageView.isHidden = true

        addSubview(rightIconImageView)
    }

    private func setupConstraints() {
        rightIconImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            rightIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingAnchor.constraint(equalTo: rightIconImageView.trailingAnchor, constant: 16.0),
        ])
    }
}
