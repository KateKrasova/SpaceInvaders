//
//  UserDataModel.swift
//  SpaceInvaders
//
//  Created by Kate on 08.10.2023.
//

struct UserDataModel: Codable {
    let name: String
    var points: Int
    let ship: Int
    let level: String
}
