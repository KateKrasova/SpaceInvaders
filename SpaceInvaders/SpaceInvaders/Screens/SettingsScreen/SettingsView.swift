//
//  SettingsView.swift
//  SpaceInvaders
//
//  Created by Kate on 05.10.2023.
//

import UIKit
import SnapKit
import SwiftBoost

final class SettingsView: UIView {
    // MARK: - Props

    struct Props: Equatable {
        let userName: String
        let ship: Int
        let level: String
    }

    // MARK: - Private Props

    private var props: Props?

    var name = "Unknown User"
    var ship = 1
    var level = "Easy"

    // MARK: - Views

    private lazy var enterNameLabel = UILabel().do {
        $0.text = "Enter your name"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: Constants.fontSize24, weight: .bold)
        $0.textAlignment = .center
    }

    private lazy var enterNameTextField = UITextField().do {
        $0.placeholder = "Unknown User"
        $0.borderStyle = .roundedRect
        $0.delegate = self
        $0.returnKeyType = .done
        $0.backgroundColor = .darkGray
    }

    private lazy var shipSegmentedControl =  UISegmentedControl(items: ["Ship 1", "Ship 2", "Ship 3"]).do {
        $0.selectedSegmentIndex = 0
        $0.addTarget(self, action: #selector(shipChanged(_:)), for: .valueChanged)
    }

    private lazy var shipImage = UIImageView().do {
        $0.image = Asset.Images.ship1.image
        $0.contentMode = .scaleAspectFit
    }

    private lazy var levelSegmentedControl =  UISegmentedControl(items: ["Easy", "Middle", "Hard"]).do {
        $0.selectedSegmentIndex = 0
        $0.addTarget(self, action: #selector(levelChanged(_:)), for: .valueChanged)
    }

    // MARK: - LifeCycle

    init() {
        super.init(frame: .zero)

        setup()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Methods

extension SettingsView {
    func saveSettings() {
        var user = UserDefaultsService.user
        user = .init(name: name, points: 0, ship: ship, level: level)
        UserDefaultsService.user = user
    }

    func updateInfo(info: Props) {
        enterNameTextField.text = info.userName
        shipSegmentedControl.selectedSegmentIndex = info.ship - 1

        switch info.ship {
        case 1:
            shipImage.image = Asset.Images.ship1.image
        case 2:
            shipImage.image = Asset.Images.ship2.image
        case 3:
            shipImage.image = Asset.Images.ship3.image
        default: break
        }

        switch info.level {
        case "Easy":
            levelSegmentedControl.selectedSegmentIndex = 0
        case "Middle":
            levelSegmentedControl.selectedSegmentIndex = 1
        case "Hard":
            levelSegmentedControl.selectedSegmentIndex = 2

        default: break
        }

        name = info.userName
        ship = info.ship
        level = info.level

    }
}

// MARK: - Private Methods

private extension SettingsView {
    func setup() {
        backgroundColor = .black

        addSubviews(
            enterNameLabel,
            enterNameTextField,
            shipSegmentedControl,
            shipImage,
            levelSegmentedControl
        )
    }

    func setupConstraints() {
        enterNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constants.offset16)
        }

        enterNameTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.offset24)
            $0.top.equalTo(enterNameLabel.snp.bottom).offset(Constants.offset16)
        }

        shipSegmentedControl.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.offset24)
            $0.top.equalTo(enterNameTextField.snp.bottom).offset(Constants.offset16)
        }

        shipImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(Constants.shipRatio)
            $0.top.equalTo(shipSegmentedControl.snp.bottom).offset(Constants.offset50)
        }

        levelSegmentedControl.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.offset24)
            $0.top.equalTo(shipImage.snp.bottom).offset(Constants.offset16)
        }
    }

    @objc
    func shipChanged(_ sender: UISegmentedControl) {
        switch shipSegmentedControl.selectedSegmentIndex {
        case 0:
            shipImage.image = Asset.Images.ship1.image
            ship = 1
        case 1:
            shipImage.image = Asset.Images.ship2.image
            ship = 2
        case 2:
            shipImage.image = Asset.Images.ship3.image
            ship = 3
        default: break
        }
    }

    @objc
    func levelChanged(_ sender: UISegmentedControl) {
        switch levelSegmentedControl.selectedSegmentIndex {
        case 0:
            level = "Easy"
        case 1:
            level = "Middle"
        case 2:
            level = "Hard"

        default: break
        }
    }
}

// MARK: - UITextFieldDelegate

extension SettingsView: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != nil && textField.text?.isEmpty != true {
            name = textField.text ?? "Unknown User"
        }
    }
}

// MARK: - Constants

private extension SettingsView {
    enum Constants {
        static let fontSize24: CGFloat = 24

        static let offset16: CGFloat = 16
        static let offset24: CGFloat = 24
        static let offset50: CGFloat = 50

        static let shipRatio: Int = 6
    }
}
