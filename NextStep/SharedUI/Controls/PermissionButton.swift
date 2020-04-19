///

import UIKit

struct PermissionButtonModel {
    let identifier: String

    let icon: UIImage?
    let rightIcon: UIImage?
    let title: String
    let permissionName: String
}

final class PermissionButton: UIControl {
    private(set) var identifier: String = ""

    let iconImageView = UIImageView()
    let rightIcon = UIImageView()
    let titleLabel = UILabel()
    let permissionNameLabel = UILabel()

    init() {
        super.init(frame: .zero)

        setupComponents()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if !frame.isEmpty {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.2
            layer.shadowRadius = 8
            layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
            layer.shadowPath = CGPath(rect: CGRect(origin: .zero, size: frame.size), transform: nil)
        }
    }

    // MARK: Interface

    func setup(model: PermissionButtonModel) {
        identifier = model.identifier
        iconImageView.image = model.icon
        rightIcon.image = model.rightIcon
        titleLabel.text = model.title
        permissionNameLabel.text = model.permissionName
    }

    // MARK: Private

    private func setupComponents() {
        backgroundColor = .white

        iconImageView.contentMode = .scaleAspectFit

        rightIcon.isHidden = true

        titleLabel.textColor = UIColor.ns_black?.withAlphaComponent(0.5)
        titleLabel.font = NSLabelType.text.font
        titleLabel.numberOfLines = 0

        permissionNameLabel.textColor = .ns_secondary
        permissionNameLabel.font = NSLabelType.headline.font
        permissionNameLabel.numberOfLines = 0

        [iconImageView, titleLabel, permissionNameLabel, rightIcon].forEach(addSubview(_:))
    }

    private func setupConstraints() {
        [iconImageView, titleLabel, permissionNameLabel, rightIcon].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            iconImageView.widthAnchor.constraint(equalToConstant: 44.0),
            iconImageView.heightAnchor.constraint(equalToConstant: 44.0),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8.0),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: permissionNameLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: permissionNameLabel.trailingAnchor),
            rightIcon.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8.0),

            permissionNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),

            rightIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingAnchor.constraint(equalTo: rightIcon.trailingAnchor, constant: 16.0),
            rightIcon.widthAnchor.constraint(equalToConstant: 28.0),
            rightIcon.heightAnchor.constraint(equalToConstant: 28.0),

            bottomAnchor.constraint(equalTo: permissionNameLabel.bottomAnchor, constant: 24),
        ])
    }
}
