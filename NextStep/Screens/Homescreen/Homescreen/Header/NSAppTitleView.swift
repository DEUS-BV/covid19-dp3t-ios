/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSAppTitleView: UIView {
    // MARK: - Init

    var uiState: NSUIStateModel.Homescreen.Header = .normal {
        didSet {
            if uiState != oldValue {
                updateState(animated: true)
            }
        }
    }

    let backgroundImageView = UIImageView()
    let highlightView = UIView()

    // Safe-area aware container
    let contentView = UIView()

    // Content
    let circle = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    init() {
        super.init(frame: .zero)
        setup()
        animate()
        startSpawn()
        updateState(animated: false)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(highlightView)
        highlightView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(NSPadding.large)
        }

        contentView.addSubview(circle)
        circle.contentMode = .scaleAspectFit
        circle.snp.makeConstraints { make in
            make.height.width.equalTo(86.0)
            make.centerY.equalToSuperview().inset(NSPadding.large * 40)
            make.centerX.equalToSuperview()
        }

        contentView.addSubview(titleLabel)
        titleLabel.font = NSLabelType.headerTitle.font
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(NSPadding.large)
            make.top.equalTo(circle.snp.bottom).offset(NSPadding.large)
            make.centerX.equalToSuperview()
        }

        contentView.addSubview(subtitleLabel)
        subtitleLabel.font = NSLabelType.smallText.font
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 2
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(NSPadding.large)
            make.top.equalTo(titleLabel.snp.bottom).offset(NSPadding.medium)
            make.centerX.equalToSuperview()
        }
    }

    private func animate() {
        let initialDelay = 1.0

        circle.alpha = 0
        circle.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

        UIView.animate(withDuration: 0.3, delay: 0.0 + initialDelay, options: [], animations: {
            self.circle.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 0.0 + initialDelay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
            self.circle.transform = .identity
        }, completion: nil)
    }

    private var timer: Timer?
    private var slowTimer: Timer?
    private func startSpawn() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(spawnCircle), userInfo: nil, repeats: true)
        slowTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hightlight), userInfo: nil, repeats: true)
    }

    private var isOverscrolled = false

    @objc
    private func hightlight() {
        if uiState == .error {
            return // no highlight in error state
        }

        UIView.animate(withDuration: 2.5, animations: {
            self.highlightView.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        }) { _ in
            UIView.animate(withDuration: 2.5) {
                self.highlightView.backgroundColor = .clear
            }
        }
    }

    @objc
    private func spawnCircle(force: Bool = false) {
        if uiState != .normal {
            return // only show animation when in "normal" state
        }

        guard Float.random(in: 0 ... 1) > 0.3 || force else {
            return // drop random events
        }

        let left = NSHeaderArcView(angle: .left)
        let right = NSHeaderArcView(angle: .right)

        [left, right].forEach {
            arc in
            arc.alpha = 0
            arc.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            contentView.addSubview(arc)

            arc.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }

            UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
                arc.alpha = 1
            }) { _ in
                UIView.animate(withDuration: 1.5, delay: 0.4, options: [.beginFromCurrentState], animations: {
                    arc.alpha = 0
                }, completion: nil)
            }

            UIView.animate(withDuration: 2.0, delay: 0.0, options: [.curveLinear], animations: {
                arc.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            }) { _ in
                arc.removeFromSuperview()
            }
        }
    }

    private func updateState(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState], animations: {
                self.updateState(animated: false)
            }, completion: nil)
            return
        }

        switch uiState {
        case .normal:
            circle.image = UIImage(named: "title-circle-normal")
            backgroundImageView.image = UIImage(named: "titlebackground-normal")
            titleLabel.text = "header-no-known-contact-title".ub_localized
            subtitleLabel.text = "header-no-known-contact-subtitle".ub_localized

        case .error:
            circle.image = UIImage(named: "title-circle-warning")
            backgroundImageView.image = UIImage(named: "titlebackground-error")
            titleLabel.text = "header-covid-positive".ub_localized
            subtitleLabel.text = "header-covid-positive-subtitle".ub_localized

        case .warning:
            circle.image = UIImage(named: "title-circle-warning")
            backgroundImageView.image = UIImage(named: "titlebackground-warning")
            titleLabel.text = "header-possible-exposure".ub_localized
            subtitleLabel.text = "header-covid-possible-subtitle".ub_localized

        case .dontShow:
            circle.image = nil
            backgroundImageView.image = UIImage(named: "orange-background")
            titleLabel.text = nil
            subtitleLabel.text = nil
        }
    }
}

extension NSAppTitleView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + scrollView.safeAreaInsets.top
        let overscrolled = offset < -10
        if overscrolled != isOverscrolled {
            isOverscrolled = overscrolled

            if overscrolled {
                for delay in stride(from: 0, to: 1.0, by: 0.5) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        self.spawnCircle(force: true)
                    }
                }
            }
        }

        let inPositiveFactor = max(0, min(1, offset / 70.0))

        let a = 1.0 - inPositiveFactor
        let t1 = inPositiveFactor * 25.0
        let t2 = inPositiveFactor * -50.0
        contentView.alpha = a
        contentView.transform = CGAffineTransform(translationX: 0, y: t1)
        transform = CGAffineTransform(translationX: 0, y: t2)
    }
}
