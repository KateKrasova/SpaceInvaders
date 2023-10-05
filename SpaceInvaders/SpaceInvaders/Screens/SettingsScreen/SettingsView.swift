//
//  SettingsView.swift
//  SpaceInvaders
//
//  Created by Kate on 05.10.2023.
//

import UIKit

final class SettingsView: UIView {
    // MARK: - Props

    struct Props: Equatable {
    }

    // MARK: - Private Props

    private var props: Props?

    // MARK: - Views

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

extension SettingsView {
    func render(_ props: Props) {
        guard self.props != props else { return }
        self.props = props
    }
}

// MARK: - Private Methods

private extension SettingsView {
    /// Настройка View
    func setup() {
        backgroundColor = .clear
    }

    /// Добавление Views
    func setupViews() {
    }

    /// Установка констреинтов
    func setupConstraints() {
    }
}

// MARK: - Constants

private extension SettingsView {
    enum Constants {
    }
}
