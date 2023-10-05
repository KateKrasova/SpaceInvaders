//
//  StartScreenViewController.swift
//  SpaceInvaders
//
//  Created by Kate on 05.10.2023.
//

import UIKit

final class StartScreenViewController: UIViewController {
    // MARK: - Private props

    private let moduleView = StartScreenView()

    // MARK: - Lyfecycle

    override func loadView() {
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        moduleView.startTappedClosure = { [weak self] in
            self?.navigationController?.pushViewController(GameViewController(), animated: false)
        }

        moduleView.settingsTappedClosure = { [weak self] in
            self?.navigationController?.pushViewController(SettingsViewController(), animated: false)
        }

        moduleView.recordsTappedClosure = { [weak self] in
            self?.navigationController?.pushViewController(RecordsViewController(), animated: false)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
