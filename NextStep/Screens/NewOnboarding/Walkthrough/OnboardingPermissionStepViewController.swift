///

import CoreBluetooth
import Foundation
import UIKit

final class OnboardingPermissionStepViewController: UIViewController, OnboardingView {
    let identifier: OnboardingStep
    weak var delegate: OnboardingViewDelegate?

    private let scrollView = UIScrollView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let stackView = UIStackView()
    private let thanksLabel = UILabel()
    private var permissionButtons: [PermissionButton] = []

    private var isBluetoothEnabled: Bool = false {
        didSet {
            guard let button = permissionButtons.first(where: { $0.identifier == RequiredPermission.bluetooth.rawValue }) else { return }

            button.rightIcon.isHidden = !isBluetoothEnabled
            button.isEnabled = !isBluetoothEnabled

            updateUI()
        }
    }

    private var bluetoothAsked: Bool = false
    private var centralManager: CBCentralManager?
    private var isPushEnabled: Bool = false {
        didSet {
            guard let button = permissionButtons.first(where: { $0.identifier == RequiredPermission.notifications.rawValue }) else { return }

            button.rightIcon.isHidden = !isPushEnabled
            button.isEnabled = !isPushEnabled

            updateUI()
        }
    }

    private var pushAsked: Bool = false

    init(identifier: OnboardingStep) {
        self.identifier = identifier

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPermissionSettings()
    }

    // MARK: Interface

    var canContinue: Bool = false {
        didSet {
            delegate?.stepDidUpdateContinueState(self)
        }
    }

    var hasRequiredPermission: Bool {
        return isPushEnabled && isBluetoothEnabled
    }

    func setup(with model: OnboardingStepModel) {
        titleLabel.text = model.title
        messageLabel.text = model.message
    }

    // MARK: Private

    private func setupComponents() {
        titleLabel.textColor = UIColor.ns_black
        titleLabel.font = NSLabelType.title.font
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        messageLabel.textColor = UIColor.ns_black?.withAlphaComponent(0.7)
        messageLabel.font = NSLabelType.text.font
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        thanksLabel.font = NSLabelType.latoBlackItalic(size: 28).font
        thanksLabel.text = "permission_thanks_label".ub_localized
        thanksLabel.numberOfLines = 0
        thanksLabel.isHidden = true

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16.0
        [titleLabel, messageLabel].forEach(stackView.addArrangedSubview(_:))

        addPermissionButtons()

        stackView.setCustomSpacing(24, after: titleLabel)
        stackView.setCustomSpacing(60, after: messageLabel)

        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.clipsToBounds = false
        [stackView, thanksLabel].forEach(scrollView.addSubview(_:))

        view.addSubview(scrollView)
    }

    private func setupConstraints() {
        [scrollView, stackView, thanksLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            thanksLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            scrollView.bottomAnchor.constraint(equalTo: thanksLabel.bottomAnchor),
            thanksLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 32.0),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }

    private func addPermissionButtons() {
        let buttons = RequiredPermission.allCases.map { [weak self] (permission) -> PermissionButton in
            let button = PermissionButton()
            button.setup(model: permission.model)
            self?.setAction(to: button)

            return button
        }

        permissionButtons.append(contentsOf: buttons)
        buttons.forEach(stackView.addArrangedSubview(_:))
    }

    private func setAction(to button: PermissionButton) {
        switch button.identifier {
        case RequiredPermission.bluetooth.rawValue:
            button.addTarget(self, action: #selector(requestBluetoothPermission), for: .touchUpInside)

        case RequiredPermission.notifications.rawValue:
            button.addTarget(self, action: #selector(requestPushNotificationsPermission), for: .touchUpInside)

        default:
            break
        }
    }

    private func updateUI() {
        if isBluetoothEnabled, isPushEnabled {
            canContinue = true
            thanksLabel.isHidden = false
        } else if pushAsked, bluetoothAsked {
            canContinue = true
        }
    }

    // MARK: Permissions Check

    @objc private func requestBluetoothPermission() {
        guard !bluetoothAsked else {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            return
        }

        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: NSNumber(integerLiteral: 1)])
    }

    @objc private func requestPushNotificationsPermission() {
        UBPushManager.shared.requestPushPermissions { result in
            self.pushAsked = true

            switch result {
            case .nonRecoverableFailure, .recoverableFailure:
                self.isPushEnabled = false
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            case .success:
                self.isPushEnabled = true
            }
        }
    }

    @objc private func checkPermissionSettings() {
        if #available(iOS 13.1, *) {
            switch CBCentralManager.authorization {
            case .notDetermined:
                self.bluetoothAsked = false
                self.isBluetoothEnabled = false

            case .allowedAlways:
                self.bluetoothAsked = true
                self.isBluetoothEnabled = true

            case .denied, .restricted:
                self.bluetoothAsked = true
                self.isBluetoothEnabled = false

            @unknown default:
                fatalError("Unhadled case")
            }
        } else {
            bluetoothAsked = true
            isBluetoothEnabled = true
        }

        UBPushManager.shared.queryPushPermissions { [weak self] enabled in
            guard let self = self else { return }
            self.isPushEnabled = enabled
            print("Bluetooth: \(self.isBluetoothEnabled) / Push: \(self.isPushEnabled)")
            self.updateUI()
        }
    }
}

extension OnboardingPermissionStepViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_: CBCentralManager) {
        if #available(iOS 13.1, *) {
            switch CBCentralManager.authorization {
            case .notDetermined:
                self.bluetoothAsked = false
                self.isBluetoothEnabled = false

            case .allowedAlways:
                self.bluetoothAsked = true
                self.isBluetoothEnabled = true

            case .denied, .restricted:
                self.bluetoothAsked = true
                self.isBluetoothEnabled = false

            @unknown default:
                fatalError("Unhadled case")
            }
        } else {
            bluetoothAsked = true
            isBluetoothEnabled = true
        }
    }
}
