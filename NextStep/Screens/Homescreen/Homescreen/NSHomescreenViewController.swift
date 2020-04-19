/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import CoreBluetooth
import SnapKit
import UIKit

class NSHomescreenViewController: NSViewController {
    private let stackScrollView = NSStackScrollView()

    let titleView = NSAppTitleView()
    let languageSelectionButton = UIButton()
    let hideStatusButton = UIButton()

    private let handshakesModuleView = EncountersView()
    private let meldungView = NSMeldungView()
    private let spacerView = UIView()

    private let informButton = NSButton(title: "inform_button_title".ub_localized, style: .primaryOutline)
    private let syncButton = NSButton(title: "Sync now", style: .primaryOutline)

    // MARK: - View

    override init() {
        super.init()

        if NSContentEnvironment.current.hasTabBar {
            title = "tab_aktuell_title".ub_localized
        }

        tabBarItem.image = UIImage(named: "home")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ns_background_secondary

        setupButtons()
        setupLayout()

        meldungView.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.presentMeldungenDetail()
        }

        NSUIStateManager.shared.addObserver(self, block: updateState(_:))

        handshakesModuleView.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.presentBegegnungenDetail()
        }

        informButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            NSInformViewController.present(from: strongSelf)
        }

        syncButton.touchUpCallback = {
            NSTracingManager.shared.forceSyncDatabase()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)

        NSUIStateManager.shared.refresh()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        finishTransition?()
        finishTransition = nil

        presentOnboardingIfNeeded()
    }

    private var finishTransition: (() -> Void)?

    // MARK: - Setup

    private func setupButtons() {
        languageSelectionButton.setTitle(Languages.current.languageCode.uppercased(), for: .normal)
        languageSelectionButton.titleLabel?.font = NSLabelType.subtitle.font
        languageSelectionButton.addTarget(self,
                                          action: #selector(presentLanguageSelection),
                                          for: .touchUpInside)
        languageSelectionButton.setTitleColor(UIColor.white.withAlphaComponent(0.5),
                                              for: .normal)

        hideStatusButton.setTitle("dashboard_hide_status_button".ub_localized, for: .normal)
        hideStatusButton.setTitle("dashboard_show_status_button".ub_localized, for: .selected)
        hideStatusButton.titleLabel?.textAlignment = .right
        hideStatusButton.titleLabel?.font = NSLabelType.subtitle.font
        hideStatusButton.addTarget(self,
                                   action: #selector(toggleHiddenStatus),
                                   for: .touchUpInside)
        hideStatusButton.setTitleColor(UIColor.white.withAlphaComponent(0.5),
                                       for: .normal)
    }

    private func setupLayout() {
        view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(340)
        }

        stackScrollView.stackView.isLayoutMarginsRelativeArrangement = true
        stackScrollView.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

        view.addSubview(stackScrollView)
        stackScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackScrollView.scrollView.delegate = titleView

        spacerView.snp.makeConstraints { make in
            make.height.equalTo(290)
        }
        stackScrollView.addArrangedView(spacerView)

        stackScrollView.addArrangedView(handshakesModuleView)
        stackScrollView.addSpacerView(NSPadding.large)

        stackScrollView.addArrangedView(meldungView)
        stackScrollView.addSpacerView(NSPadding.large)

        let buttonContainer = UIView()
        buttonContainer.addSubview(informButton)
        informButton.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
        }
        stackScrollView.addArrangedView(buttonContainer)
        stackScrollView.addSpacerView(NSPadding.large)

        #if SHOW_SYNC
            let syncButtonContainer = UIView()
            syncButtonContainer.addSubview(syncButton)
            syncButton.snp.makeConstraints { make in
                make.top.bottom.centerX.equalToSuperview()
            }
            stackScrollView.addArrangedView(syncButtonContainer)
            stackScrollView.addSpacerView(NSPadding.large)
        #endif

        view.addSubview(languageSelectionButton)
        view.addSubview(hideStatusButton)

        languageSelectionButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30.0)
            make.height.width.greaterThanOrEqualTo(30.0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(4.0)
            make.trailing.lessThanOrEqualTo(hideStatusButton.snp.leading).inset(8.0)
        }

        hideStatusButton.titleLabel?.numberOfLines = 0
        hideStatusButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30.0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(4.0)
        }

        handshakesModuleView.alpha = 0
        meldungView.alpha = 0
        informButton.alpha = 0

        finishTransition = {
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [.allowUserInteraction], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)

            UIView.animate(withDuration: 0.3, delay: 0.35, options: [.allowUserInteraction], animations: {
                self.handshakesModuleView.alpha = 1
            }, completion: nil)
            UIView.animate(withDuration: 0.3, delay: 0.5, options: [.allowUserInteraction], animations: {
                self.meldungView.alpha = 1
            }, completion: nil)
            UIView.animate(withDuration: 0.3, delay: 0.65, options: [.allowUserInteraction], animations: {
                if NSUIStateManager.shared.uiState.homescreen.meldungButtonDisabled {
                    self.informButton.alpha = 0.2
                } else {
                    self.informButton.alpha = 1.0
                }
            }, completion: nil)
        }
    }

    func updateState(_ state: NSUIStateModel) {
        titleView.uiState = state.homescreen.header
        handshakesModuleView.uiState = state.homescreen.begegnungen.tracing
        meldungView.uiState = state.homescreen.meldungen

        if state.homescreen.meldungButtonDisabled {
            informButton.isEnabled = false
            informButton.alpha = 0.2
        } else {
            informButton.isEnabled = true
            informButton.alpha = 1.0
        }
    }

    // MARK: - Actions

    @objc private func presentLanguageSelection() {
        present(LanguageSelectionViewController(mode: .settings), animated: true, completion: nil)
    }

    @objc private func toggleHiddenStatus() {
        hideStatusButton.isSelected = !hideStatusButton.isSelected
        if hideStatusButton.isSelected {
            titleView.uiState = .dontShow
            spacerView.snp.remakeConstraints { make in
                make.height.equalTo(80)
            }
            titleView.snp.remakeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(140)
            }
        } else {
            titleView.uiState = NSUIStateManager.shared.uiState.homescreen.header
            spacerView.snp.remakeConstraints { make in
                make.height.equalTo(290)
            }
            titleView.snp.remakeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(340)
            }
        }
    }

    // MARK: - Details

    private func presentBegegnungenDetail() {
        navigationController?.pushViewController(NSBegegnungenDetailViewController(), animated: true)
    }

    private func presentMeldungenDetail() {
        navigationController?.pushViewController(NSMeldungenDetailViewController(), animated: true)
    }

    private func presentOnboardingIfNeeded() {
        if !User.shared.hasCompletedOnboarding {
            let onboardingViewController = OnboardingViewController()
            onboardingViewController.modalPresentationStyle = .fullScreen
            present(onboardingViewController, animated: false)
        }
    }
}
