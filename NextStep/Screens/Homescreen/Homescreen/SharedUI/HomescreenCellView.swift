///

import UIKit

class HomescreenCellView: UIControl {

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let forwardiconImageView = UIImageView()

    init(image: UIImage, title: String, subtitle: NSAttributedString) {
        super.init(frame: .zero)
        imageView.image = image
        titleLabel.text = title
        subtitleLabel.attributedText = subtitle
        setupComponents()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Interface

    // MARK: - Private
    private func setupComponents() {
        imageView.contentMode = .scaleAspectFit

        titleLabel.font = NSLabelType.headline.font
        titleLabel.textAlignment = .left

        forwardiconImageView.image = UIImage(named: "ic-forward")

        [imageView, titleLabel, subtitleLabel, forwardiconImageView].forEach { addSubview($0) }
    }

    private func setupConstraints() {
        [imageView, titleLabel, subtitleLabel, forwardiconImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18.0),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            imageView.heightAnchor.constraint(equalToConstant: 32.0),
            imageView.widthAnchor.constraint(equalToConstant: 32.0),

            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10.0),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: forwardiconImageView.leadingAnchor, constant: 4.0),
            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.0),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: forwardiconImageView.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24.0)
        ])
    }
}
