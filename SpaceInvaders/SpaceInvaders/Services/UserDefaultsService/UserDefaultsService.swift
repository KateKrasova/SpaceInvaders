//
//  UserDefaultsService.swift
//  SpaceInvaders
//
//  Created by Kate on 08.10.2023.
//

import Foundation

struct UserDefaultsService {
    enum Keys: String {
        case user
        case userRecords
    }

    static var user: UserDataModel? {
        get {
            if let data = UserDefaults.standard.value(forKey: Keys.user.rawValue) as? Data {
                if let dataFromDB = try? PropertyListDecoder().decode(UserDataModel.self, from: data) {
                   return dataFromDB
                }
            }
            return UserDataModel(name: "Unknown User", points: 0, ship: 1, level: "Easy")
        }
        set {
            UserDefaults.standard.setValue(try? PropertyListEncoder().encode(newValue), forKey: Keys.user.rawValue)
        }
    }

    static var userRecords: [UserDataModel]? {
        get {
            if let data = UserDefaults.standard.value(forKey: Keys.userRecords.rawValue) as? Data {
                if let dataFromDB = try? PropertyListDecoder().decode(Array<UserDataModel>.self, from: data) {
                   return dataFromDB
                }
            }
            return []
        }
        set {
            UserDefaults.standard.setValue(try? PropertyListEncoder().encode(newValue), forKey: Keys.userRecords.rawValue)
        }
    }
}
