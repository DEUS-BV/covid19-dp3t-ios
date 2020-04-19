/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSBluetoothSettingsDetailView: UIView {
    // MARK: - Views

    private let mainLabel = UILabel()
    private let subtextLabel = NSLabel(.text)
    private let imageView = UIImageView()

    private let additionalLabel = NSLabel(.textSemiBold)

    // MARK: - Init

    init(title: String, subText: String, image: UIImage?, titleColor: UIColor, subtextColor: UIColor, backgroundColor: UIColor? = .clear, backgroundInset: Bool = true, hasBubble: Bool = false, additionalText: String? = nil) {
        super.init(frame: .zero)

        mainLabel.attributedText = createAttributedTitle(from: title, and: subText)
        mainLabel.textColor = titleColor
        mainLabel.numberOfLines = 0
        mainLabel.accessibilityLanguage = Languages.current.languageCode

        subtextLabel.text = subText
        subtextLabel.textColor = subtextColor
        subtextLabel.accessibilityLanguage = Languages.current.languageCode

        imageView.image = image

        additionalLabel.textColor = subtextColor
        additionalLabel.accessibilityLanguage = Languages.current.languageCode

        setup(backgroundColor: backgroundColor, backgroundInset: backgroundInset, hasBubble: hasBubble, additionalText: additionalText)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(backgroundColor: UIColor?, backgroundInset: Bool, hasBubble: Bool, additionalText: String? = nil) {
        var topBottomPadding: CGFloat = 0

        if let bgc = backgroundColor {
            let v = UIView()
            v.layer.cornerRadius = 3.0
            addSubview(v)

            v.snp.makeConstraints { make in
                if backgroundInset {
                    make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: NSPadding.medium, bottom: 0, right: NSPadding.medium))
                } else {
                    make.edges.equalToSuperview()
                }
            }

            v.backgroundColor = bgc

            if hasBubble {
                let imageView = UIImageView(image: UIImage(named: "bubble")?.withRenderingMode(.alwaysTemplate))
                imageView.tintColor = bgc
                addSubview(imageView)

                imageView.snp.makeConstraints { make in
                    make.top.equalTo(self.snp.bottom)
                    make.left.equalToSuperview().inset(NSPadding.large)
                }
            }

            topBottomPadding = backgroundInset ? 14.0 : (2.0 * NSPadding.medium)
        }

        addSubview(mainLabel)
        addSubview(imageView)

        imageView.ub_setContentPriorityRequired()

        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(NSPadding.medium * 2.0)
            make.top.equalTo(mainLabel.snp.top)
            make.width.height.equalTo(24.0)
        }

        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(topBottomPadding + 3.0)
            make.left.equalTo(self.imageView.snp.right).offset(NSPadding.medium)
            make.right.equalToSuperview().inset(NSPadding.medium * 2.0)
            if additionalText == nil {
                make.bottom.equalToSuperview().inset(topBottomPadding)
            }
        }

        if let adt = additionalText {
            addSubview(additionalLabel)
            additionalLabel.text = adt

            additionalLabel.snp.makeConstraints { make in
                make.top.equalTo(self.mainLabel.snp.bottom).offset(NSPadding.medium)
                make.left.right.equalTo(self.mainLabel)
                make.bottom.equalToSuperview().inset(topBottomPadding)
            }
        }
    }

    private func createAttributedTitle(from title: String, and subtitle: String) -> NSAttributedString {
        let boldFont = NSLabelType.textSemiBold.font
        let normalFont = NSLabelType.text.font
        let textColor = UIColor.homescreen_text
        let resultString = NSMutableAttributedString(string: title,
                                                     attributes: [.font: boldFont,
                                                                  .foregroundColor: textColor])
        resultString.append(NSAttributedString(string: " - ",
                                               attributes: [.font: normalFont,
                                                            .foregroundColor: textColor]))
        resultString.append(NSAttributedString(string: subtitle,
                                               attributes: [.font: normalFont,
                                                            .foregroundColor: textColor]))

        return resultString
    }
}
