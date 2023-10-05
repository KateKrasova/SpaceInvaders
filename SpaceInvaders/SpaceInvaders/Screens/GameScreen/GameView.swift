//
//  GameView.swift
//  SpaceInvaders
//
//  Created by Kate on 05.10.2023.
//

import UIKit
import SnapKit
import SwiftBoost

final class GameView: UIView {
    // MARK: - Props

    struct Props: Equatable {
    }

    // MARK: - Private Props

    private var props: Props?

    // MARK: - Views

    private lazy var rightButton = UIButton(type: .system).do {
        $0.setImage(UIImage(systemName: "arrowshape.right.fill"), for: .normal)
        $0.tintColor = .white
    }

    private lazy var leftButton = UIButton(type: .system).do {
        $0.setImage(UIImage(systemName: "arrowshape.left.fill"), for: .normal)
        $0.tintColor = .white
    }

    private lazy var shotButton = UIButton(type: .system).do {
        $0.setTitle("  SHOT  ", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(Asset.Colors.redMain.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.borderColor = Asset.Colors.redMain.color
        $0.borderWidth = 2
    }

    private lazy var shipImage = UIImageView().do {
        $0.image = Asset.Images.ship1.image
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - LifeCycle

    init() {
        super.init(frame: .zero)

        setup()
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Methods

extension GameView {
    func render(_ props: Props) {
        guard self.props != props else { return }
        self.props = props
    }
}

// MARK: - Private Methods

private extension GameView {
    /// Настройка View
    func setup() {
        backgroundColor = .black

        addSubviews(
            leftButton,
            rightButton,
            shotButton,
            shipImage
        )
    }

    /// Добавление Views
    func setupViews() {
    }

    /// Установка констреинтов
    func setupConstraints() {
        leftButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.offset16)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-Constants.offset16)
        }

        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.offset16)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-Constants.offset16)
        }

        shotButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(rightButton)
            $0.height.equalTo(Constants.buttonsSize)
        }

        shipImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(shotButton.snp.top).offset(-Constants.offset16)
            $0.height.equalTo(Constants.shipHight)
        }
    }
}

// MARK: - Constants

private extension GameView {
    enum Constants {
        static let buttonsSize: CGFloat = 35
        static let offset16: CGFloat = 16
        static let shipHight: CGFloat = 50
    }
}
