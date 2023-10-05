//
//  GameViewController.swift
//  SpaceInvaders
//
//  Created by Kate on 05.10.2023.
//

import UIKit

final class GameViewController: UIViewController {
    // MARK: - Private props

    private let moduleView = GameView()

    // MARK: - Lyfecycle

    override func loadView() {
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
