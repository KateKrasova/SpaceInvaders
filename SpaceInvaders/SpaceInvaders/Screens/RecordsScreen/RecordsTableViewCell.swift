//
//  RecordsTableViewCell.swift
//  SpaceInvaders
//
//  Created by Kate on 08.10.2023.
//

import SnapKit
import SwiftBoost
import UIKit

final class RecordsTableViewCell: UITableViewCell {
    // MARK: - Props

    struct Props: Equatable {
        let number: Int
        let name: String
        let points: Int
        let level: String
    }

    // MARK: - Views

    private lazy var mainLabel = UILabel().do {
        $0.textColor = Asset.Colors.yellowMain.color
        $0.font = .systemFont(ofSize: Constants.font24, weight: .semibold)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }

    // MARK: - LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        mainLabel.text = nil
    }
}

// MARK: - Internal Methods

extension RecordsTableViewCell {
    func updateViews(_ props: Props) {
        mainLabel.text = "\(props.number). \(props.name)(\(props.level)) - \(props.points)"
    }
}

// MARK: - Private Methods

private extension RecordsTableViewCell {
    func setup() {
        backgroundColor = .black

        contentView.addSubviews(
            mainLabel
        )
    }

    func setupConstraints() {
        mainLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.offset8)
            $0.leading.trailing.equalToSuperview().inset(Constants.offset16)
        }
    }
}

// MARK: - Constants

private extension RecordsTableViewCell {
    enum Constants {
        static let font24: CGFloat = 24

        static let offset8: CGFloat = 8
        static let offset16: CGFloat = 16
    }
}

