//
//  StartScreenView.swift
//  SpaceInvaders
//
//  Created by Kate on 05.10.2023.
//

import UIKit
import SnapKit
import SwiftBoost

final class StartScreenView: UIView {
    // MARK: - Props

    var startTappedClosure: (()->Void)?
    var settingsTappedClosure: (()->Void)?
    var recordsTappedClosure: (()->Void)?

    // MARK: - Views

    private lazy var gameImage = UIImageView().do {
        $0.image = Asset.Images.logo.image
        $0.contentMode = .scaleAspectFit
    }

    private lazy var startGameButton = UIButton(type: .system).do {
        $0.setTitle("Start")
        $0.backgroundColor = .black
        $0.setTitleColor(Asset.Colors.yellowMain.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.borderColor = Asset.Colors.yellowMain.color
        $0.borderWidth = 1
        $0.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
    }

    private lazy var settingsButton = UIButton(type: .system).do {
        $0.setTitle("Settings")
        $0.backgroundColor = .black
        $0.setTitleColor(Asset.Colors.yellowMain.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.borderColor = Asset.Colors.yellowMain.color
        $0.borderWidth = 1
        $0.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
    }

    private lazy var recordsButton = UIButton(type: .system).do {
        $0.setTitle("Records")
        $0.backgroundColor = .black
        $0.setTitleColor(Asset.Colors.yellowMain.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.borderColor = Asset.Colors.yellowMain.color
        $0.borderWidth = 1
        $0.addTarget(self, action: #selector(recordsTapped), for: .touchUpInside)
    }

    private lazy var buttonsStack = UIStackView().do {
        $0.axis = .vertical
        $0.spacing = 16
        $0.addArrangedSubview(startGameButton)
        $0.addArrangedSubview(settingsButton)
        $0.addArrangedSubview(recordsButton)
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

// MARK: - Private Methods

private extension StartScreenView {
    /// Настройка View
    func setup() {
        backgroundColor = .black

        addSubviews(gameImage, buttonsStack)
    }


    /// Установка констреинтов
    func setupConstraints() {
        buttonsStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.offset50)
            $0.top.equalTo(gameImage.snp.bottom).offset(Constants.offset50)
        }

        gameImage.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.offset50)
            $0.top.equalToSuperview().inset(Constants.offset50)
            $0.height.equalToSuperview().dividedBy(Constants.imageRatioHeight)
        }

        startGameButton.snp.makeConstraints {
            $0.height.equalTo(Constants.offset50)
        }

        settingsButton.snp.makeConstraints {
            $0.height.equalTo(Constants.offset50)
        }

        recordsButton.snp.makeConstraints {
            $0.height.equalTo(Constants.offset50)
        }
    }

    @objc
    func startTapped() {
        startTappedClosure?()
    }

    @objc
    func settingsTapped() {
        settingsTappedClosure?()
    }

    @objc
    func recordsTapped() {
        recordsTappedClosure?()
    }
}

// MARK: - Constants

private extension StartScreenView {
    enum Constants {
        static let offset50: CGFloat = 50
        static let imageRatioHeight: CGFloat = 3
    }
}
