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
    // MARK: - Nested

    private struct MovingView {
        let view: UIView
        let constrant: Constraint?
        var offset: CGFloat
    }

    // MARK: - Props

    struct Props: Equatable {
    }

    var alertClosure: (()->Void)?

    // MARK: - Private Props

    private var props: Props?

    private var shipCenterConstraint: Constraint?
    private var shipCenterOffset = 0.0

    private var aliansOnScreen: [MovingView] = []
    private var bulletsOnScreen: [MovingView] = []

    private var isGameOver = false

    private var points = 0 {
        didSet {
            pointsLabel.text = "\(points)"
        }
    }

    private var user = UserDefaultsService.user

    // MARK: - Views

    private lazy var pointsLabel = UILabel().do {
        $0.text = "\(points)"
        $0.font = .systemFont(ofSize: Constants.fontSize24, weight: .bold)
        $0.textColor = Asset.Colors.yellowMain.color
    }

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
        $0.titleLabel?.font = .systemFont(ofSize: Constants.fontSize16, weight: .bold)
        $0.layer.cornerRadius = Constants.buttonRadius
        $0.clipsToBounds = true
        $0.borderColor = Asset.Colors.redMain.color
        $0.borderWidth = Constants.buttonBorderWidth
        $0.addTarget(self, action: #selector(shotButtonTap), for: .touchUpInside)
    }

    private lazy var shipImage = UIImageView().do {
        $0.contentMode = .scaleAspectFit
        switch user?.ship {
        case 1:
            $0.image = Asset.Images.ship1.image
        case 2:
            $0.image = Asset.Images.ship2.image
        case 3:
            $0.image = Asset.Images.ship3.image
        default:
            break
        }
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
            pointsLabel,
            leftButton,
            rightButton,
            shotButton,
            shipImage
        )

        createTimers()
    }

    /// Установка констреинтов
    func setupConstraints() {
        pointsLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.offset16)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constants.offset16)
        }

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
        guard abs(shipCenterOffset - 10) <= abs(self.frame.width / 2 - 50.0) else { return }
        shipCenterOffset -= 10

        changeShipPosition()
    }

    @objc
    private func rightButtonTap() {
        guard abs(shipCenterOffset + 10) <= abs(self.frame.width / 2 - 50.0) else { return }
        shipCenterOffset += 10

        changeShipPosition()
    }

    @objc
    private func shotButtonTap() {
        let bulletView = UIView().do {
            $0.backgroundColor = .white
            $0.roundCorners(curve: .circular, radius: Constants.bulletSize / 2)
        }

        addSubview(bulletView)

        var bulletBottomConstraint: Constraint?
        bulletView.snp.makeConstraints {
            bulletBottomConstraint = $0.bottom.equalTo(shipImage.snp.top).constraint
            $0.centerX.equalToSuperview().offset(shipCenterOffset)

            $0.size.equalTo(CGSize(width: Constants.bulletSize, height: Constants.bulletSize))
        }

        bulletsOnScreen.append(.init(view: bulletView, constrant: bulletBottomConstraint, offset: 0.0))
    }

    private func changeShipPosition() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5
        ) {
            self.shipCenterConstraint?.update(offset: self.shipCenterOffset)
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Timers

private extension GameView {
    func createTimers() {
        // MARK: Update State

        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
            guard let self else { return }

            // Chech Crash

            var items: Set<UIView> = []

            aliansOnScreen.forEach { [bulletsOnScreen] alian in
                bulletsOnScreen.forEach { bullet in
                    if abs(alian.view.center.y - bullet.view.center.y) <= 12 && abs(alian.view.center.x - bullet.view.center.x) <= 16 {
                        items.insert(alian.view)
                        items.insert(bullet.view)
                        self.points += 1
                    }
                }
            }


            items.forEach { item in
                item.removeFromSuperview()

                self.aliansOnScreen.removeAll(where: { $0.view == item })
                self.bulletsOnScreen.removeAll(where: { $0.view == item })
            }

            // Moving Alians

            for index in (0..<aliansOnScreen.count) {
                aliansOnScreen[index].offset += 1
                aliansOnScreen[index].constrant?.update(offset: aliansOnScreen[index].offset)

                if abs(aliansOnScreen[index].offset) > (frame.height - safeAreaInsets.bottom - 210.0) {
                    alertClosure?()

                    var array = UserDefaultsService.userRecords
                    guard let user else {return}
                    array?.append(.init(name: user.name, points: points, ship: user.ship, level: user.level))
                    UserDefaultsService.userRecords = array

                    timer.invalidate()
                    isGameOver = true

                    return
                }
            }

            // Moving Bullets

            var indexes: Set<Int> = []
            for index in (0..<bulletsOnScreen.count) {
                bulletsOnScreen[index].offset -= 1
                bulletsOnScreen[index].constrant?.update(offset: bulletsOnScreen[index].offset)

                if abs(bulletsOnScreen[index].offset) > (frame.height - safeAreaInsets.top - 80.0) {
                    indexes.insert(index)
                }
            }
            indexes.forEach { index in
                self.bulletsOnScreen[index].view.removeFromSuperview()
                self.bulletsOnScreen.remove(at: index)
            }
        }

        // MARK: Spawn Alian

        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] timer in
            if self?.isGameOver == true {
                timer.invalidate()
                return
            }

            guard let self else { return }

            let alianImageView = UIImageView(image: Asset.Images.alien.image).do {
                $0.contentMode = .scaleAspectFit
            }

            addSubview(alianImageView)

            var alianTopConstraint: Constraint?
            alianImageView.snp.makeConstraints {
                alianTopConstraint = $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).constraint
                $0.centerX.equalToSuperview().offset(Int.random(in: -Int((self.frame.width / 2))..<Int((self.frame.width / 2))))

                $0.size.equalTo(CGSize(width: 32.0, height: 24.0))
            }

            aliansOnScreen.append(.init(view: alianImageView, constrant: alianTopConstraint, offset: 0.0))
        }
    }
}

// MARK: - Constants

private extension GameView {
    enum Constants {
        static let fontSize24: CGFloat = 24
        static let fontSize16: CGFloat = 16

        static let buttonRadius: CGFloat = 12
        static let buttonBorderWidth: CGFloat = 2

        static let buttonsSize: CGFloat = 35
        static let offset16: CGFloat = 16
        static let shipHight: CGFloat = 50
        static let bulletSize: CGFloat = 5

    }
}
