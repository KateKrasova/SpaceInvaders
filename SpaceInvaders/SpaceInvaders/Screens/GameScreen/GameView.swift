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

    private var shipCenterConstraint: Constraint?
    private var shipCenterOffset = 0.0

    // MARK: - Views

    private lazy var leftButton = UIButton(type: .system).do {
        $0.setImage(UIImage(systemName: "arrowshape.left.fill"), for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(leftButtonTap), for: .touchUpInside)
    }

    private lazy var rightButton = UIButton(type: .system).do {
        $0.setImage(UIImage(systemName: "arrowshape.right.fill"), for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(rightButtonTap), for: .touchUpInside)
    }

    private lazy var shotButton = UIButton(type: .system).do {
        $0.setTitle("  SHOT  ", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(Asset.Colors.redMain.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: Constants.shotButtonFontSize, weight: .bold)
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.clipsToBounds = true
        $0.borderColor = Asset.Colors.redMain.color
        $0.borderWidth = Constants.shotBorderWidth
        $0.addTarget(self, action: #selector(shotButtonTap), for: .touchUpInside)
    }

    private lazy var shipImage = UIImageView().do {
        $0.image = Asset.Images.ship1.image
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
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
            shipCenterConstraint = $0.centerX.equalToSuperview().constraint

            $0.bottom.equalTo(shotButton.snp.top).offset(-Constants.offset16)
            $0.height.equalTo(Constants.shipHight)
        }
    }

    @objc
    private func leftButtonTap() {
        shipCenterOffset -= Constants.centerOffset

        guard abs(shipCenterOffset) <= abs(self.frame.width / 2 - 50.0) else { return }

        shipCenterConstraint?.update(offset: shipCenterOffset)
    }

    @objc
    private func rightButtonTap() {
        shipCenterOffset += Constants.centerOffset

        guard abs(shipCenterOffset) <= abs(self.frame.width / 2 - 50.0) else { return }

        shipCenterConstraint?.update(offset: shipCenterOffset)
    }

    @objc
    private func shotButtonTap() {
        let view = UIView().do {
            $0.backgroundColor = .white
            $0.roundCorners(curve: .circular, radius: Constants.cartridgeSize / 2)
        }

        addSubview(view)

        var pointBottomConstraint: Constraint?
        var pointBottomOffset = 0.0

        view.snp.makeConstraints {
            pointBottomConstraint = $0.bottom.equalTo(shipImage.snp.top).constraint
            $0.centerX.equalToSuperview().offset(shipCenterOffset)

            $0.size.equalTo(CGSize(width: Constants.cartridgeSize, height: Constants.cartridgeSize))
        }

        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
            guard let self else { return }

            pointBottomOffset -= Constants.pointOffset
            pointBottomConstraint?.update(offset: pointBottomOffset)

            if abs(pointBottomOffset) > (frame.height - safeAreaInsets.top) {
                timer.invalidate()
                view.removeFromSuperview()
            }
        }
    }
}

// MARK: - Constants

private extension GameView {
    enum Constants {
        static let buttonsSize: CGFloat = 35
        static let offset16: CGFloat = 16
        static let shipHight: CGFloat = 50
        static let cartridgeSize: CGFloat = 5
        static let shotButtonFontSize: CGFloat = 16
        static let cornerRadius: CGFloat = 12
        static let shotBorderWidth: CGFloat = 2
        static let centerOffset: Double = 10
        static let pointOffset: Double = 1
    }
}
